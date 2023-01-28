reset session

myTimeFmt  = '%d/%m/%Y'
DateStart  = '01/01/2022'
DateEnd    = '31/12/2022'
SecsPerDay = 24*3600

set print $Data
	do for [t=strptime(myTimeFmt,DateStart):strptime(myTimeFmt,DateEnd):SecsPerDay] {
		print strftime(myTimeFmt,t)
	}
set print

set xrange[0.5:31.5]
set xtics 1 scale 0 offset 0,0.5 font 'Times, 12'
set link x2 via x inverse x
set x2tics 1 out scale 0 offset 0,-0.5 font 'Times, 12'
set yrange [:] reverse noextend
set ytics 1 scale 0
set key noautotitle
set style fill solid 1 border lc '#A6B5C5'
set border lc rgb '#A6B5C5'
set lmargin 7

# y=0 only month, y=1 month+year
Month(t)        = int(tm_year(t)*12 + tm_mon(t))
MonthLabel(t,y) = strftime( y=0 ? '%b %Y' : '%b', t)
WeekDay(t)      = strftime('%a',t)[1:1]
DayColor(t)     = tm_wday(t) == 0 ? 0x682424 : tm_wday(t) == 6 ? 0x244444 : 0x242628
MonthFirst(t)   = int(strptime('%Y%m%d',sprintf('%04d%02d01',tm_year(t),tm_mon(t)+1)))
MonthOffset(t)  = tm_wday(MonthFirst(t))==0 ? 7 : tm_wday(MonthFirst(t))
set xrange[*:*]

Max=`awk -F, 'FNR>1{print $1}' 'data.csv' | uniq -c | awk -v OFS=',' '$1>1{print $1}' | sort -g | tail -n 1`
Lv1 = Max / 4 * 1
Lv2 = Max / 4 * 2
Lv3 = Max / 4 * 3

# Color 1 -> $1>0   && $1<=Lv1
# Color 2 -> $1>Lv1 && $1<=Lv2
# Color 3 -> $1>Lv2 && $1<=Lv3
# Color 4 -> $1>Lv3 && $1<=Max

set terminal pngcairo size 1120,420 enhanced font 'Times, 12' enhanced background '#141618'

plot $Data u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(0.5):(0.5):(DayColor(t)): \
	xtic(WeekDay(t)):x2tic(WeekDay(t)):ytic(MonthLabel(t,1)) w boxxy lc rgb var, \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '($1>0 && $1<=".sprintf('%d', Lv1)."){print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(0.5):(0.5) w boxxy lc rgb '#0e4429', \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '($1>".sprintf('%d', Lv1)." && $1<=".sprintf('%d', Lv2)."){print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(0.5):(0.5) w boxxy lc rgb '#006d32', \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '($1>".sprintf('%d', Lv2)." && $1<=".sprintf('%d', Lv3)."){print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(0.5):(0.5) w boxxy lc rgb '#26a641', \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '($1>".sprintf('%d', Lv3)." && $1<=".sprintf('%d', Max)."){print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(0.5):(0.5) w boxxy lc rgb '#39d353', \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '$1>0 && $1<=".sprintf('%d', Lv2)."{print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(sprintf('%d',tm_mday(t))) w labels font 'Times, 11' tc rgb 'white', \
	"<awk -F, 'FNR>1{print $1}' data.csv | uniq -c | awk -v OFS=',' '$1>".sprintf('%d', Lv2)." && $1<=".sprintf('%d', Max)."{print $2}'" u (t=timecolumn(1,myTimeFmt), tm_mday(t)+MonthOffset(t)):(Month(t)):(sprintf('%d',tm_mday(t))) w labels font 'Times, 11' tc rgb 'black'
