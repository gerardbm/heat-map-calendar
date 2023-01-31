# A heat map calendar in gnuplot

Generate a heat map calendar using gnuplot and a CSV file with events.

![A heat map calendar](calendar.png?)

**This calendar displays the frequency of events in a day**: the more events, the brightest is the green. Algorithmically, this program (via `awk`) gets the day with more events and counts them to have the highest value (for internal reference): which represents the 100%. Then, it counts the events of every day and assigns a color according to the corresponding percentage. There are **four** colors for four frequencies.

```
From 0% to 25%: darkest green background and white text.
From 25% to 50%: dark green background and white text.
From 50% to 75%: bright green background and black text.
From 75% to 100%: brightest green background and black text.
```

The days without events don't show the date, only a black background. Weekends are also represented in different color: dark blue for Saturdays and dark red for Sundays.

This calendar can be customized to display a different range of dates and a different size.

How to use it: populate a file (`data.csv`) with dates in the first column with the format `dd/mm/yyyy`. The format and the column number can also be easily customized.

## Possible use cases

- Commits on Github
- Activity tracking
- Data science
- Yearly sales
