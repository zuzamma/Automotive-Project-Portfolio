import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('automotive_analysis_clean_cars.csv')

df['holding_cost'] = df['daysonmarket'] * 40

df['inventory_status'] = pd.cut(df['daysonmarket'], 
                                bins=[0, 30, 60, 90, 10000], 
                                labels=['1. Fresh', '2. Standard', '3. Slow', '4. TRAP'])

trap_cars = df[df['inventory_status'] == '4. TRAP']
brand_losses = trap_cars.groupby('make_name')['holding_cost'].sum().sort_values(ascending=False).head(10)

plt.figure(figsize=(12, 6))
sns.barplot(x=brand_losses.index, y=brand_losses.values / 1000000, palette='Reds_r')
plt.title('Financial Impact: TOP 10 Brands in TRAP Group (>90 Days)')
plt.ylabel('Total Holding Cost (Million USD)')
plt.xlabel('Car Brand')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 8))
correlation = df[['price', 'daysonmarket', 'year', 'holding_cost']].corr()
sns.heatmap(correlation, annot=True, cmap='coolwarm', fmt=".2f", linewidths=0.5)
plt.title('Market Dynamics: Feature Correlation Matrix')
plt.tight_layout()
plt.show()

plt.figure(figsize=(12, 8))
plt.scatter(df['daysonmarket'], df['price'], alpha=0.4, c=df['holding_cost'], cmap='YlOrRd')
plt.axvline(df['daysonmarket'].mean(), color='blue', linestyle='--', label='Avg Days on Market')
plt.axhline(df['price'].mean(), color='black', linestyle='--', label='Avg Price')
plt.title('Inventory Strategy: Price vs. Days on Market')
plt.xlabel('Days on Market')
plt.ylabel('Price (USD)')
plt.colorbar(label='Total Holding Cost (USD)')
plt.legend()
plt.tight_layout()
plt.show()

df.to_csv('dane_do_powerbi.csv', index=False)
print("Analysis complete. 'dane_do_powerbi.csv' has been generated.")
