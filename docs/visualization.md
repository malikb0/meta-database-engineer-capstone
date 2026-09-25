# Visualization

The Tableau analysis built on top of the restaurant data: derived fields, the individual
worksheets, and the interactive dashboard that combines them.

## Contents

- [Data source](#data-source)
- [Derived fields](#derived-fields)
- [Worksheets](#worksheets)
- [Interactive dashboard](#interactive-dashboard)
- [Related documents](#related-documents)

## Data source

The workbook reads an Excel export of the database tables,
[`clients/tableau/LittleLemonData.xlsx`](../clients/tableau/LittleLemonData.xlsx), and the
analysis is saved as
[`clients/tableau/LittleLemonDB-Tableau-Analysis.twb`](../clients/tableau/LittleLemonDB-Tableau-Analysis.twb).

```mermaid
flowchart LR
    A["LittleLemonData.xlsx"] --> B["Tableau data source"]
    B --> C["Calculated fields<br/>Profit, name split"]
    C --> D["Worksheets<br/>sales, profit, bubble, cuisine"]
    D --> E["Interactive dashboard"]
```

Source selection and filtering:

![Tableau source select and filter](../clients/tableau/Tableau-Soruce-Select-and-filter.png)

## Derived fields

| Field | Definition | Why |
|---|---|---|
| `Profit` | `Sales - Cost` | Turns revenue into a margin figure for the charts. |
| Customer name split | Split the full name into first / last | Lets the dashboard group and filter by customer. |

![Calculated profit field](../clients/tableau/Tableau-Calculated-Profit-field.png)

![Customer name split](../clients/tableau/Tableau-Customer-Name-Split.png)

## Worksheets

| Worksheet | Chart |
|---|---|
| Customer sales | Bar chart of sales per customer. |
| Profit | Trend of profit over the period. |
| Sales bubble | Bubble chart sized by sales. |
| Cuisine | Sales and profit compared by cuisine. |

![Customer sales chart](../clients/tableau/Tableau-Chart-Customer-Sales.png)

![Profit chart](../clients/tableau/Tableau-Profit-Chart.png)

![Sales bubble chart](../clients/tableau/Tableau-Sales-Bubble-Chart.png)

![Cuisine sales and profits](../clients/tableau/Tableau-Cuisine-Sales-Profits.png)

## Interactive dashboard

The worksheets are combined into a single dashboard. Clicking a customer filters the
remaining views, so the sales and cuisine breakdowns follow the selection.

![Interactive dashboard](../clients/tableau/Tableau-Interactive-dashboard.png)

## Related documents

- [Database design](database-design.md) — where the analysed data comes from.
- [Python client](python-client.md) — the other consumer of the same data.
- [Documentation index](README.md) — all docs at a glance.
