import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load and clean the dataset
df = pd.read_csv('train.csv')
df = df.dropna(subset=['Survived', 'Pclass', 'Sex', 'Age'])
df['Sex'] = df['Sex'].astype('category')

# Set up the matplotlib figure
fig, axes = plt.subplots(2, 3, figsize=(18, 10))
fig.suptitle('Titanic Data Analysis', fontsize=16)

# Chart 1: Survival Count
sns.countplot(data=df, x='Survived', ax=axes[0, 0])
axes[0, 0].set_title("Survival Count")
axes[0, 0].set_xticklabels(['Died', 'Survived'])

# Chart 2: Survival by Sex
sns.countplot(data=df, x='Sex', hue='Survived', ax=axes[0, 1])
axes[0, 1].set_title("Survival by Sex")
axes[0, 1].legend(title='Survived', labels=['Died', 'Survived'])

# Chart 3: Survival by Class
sns.countplot(data=df, x='Pclass', hue='Survived', ax=axes[0, 2])
axes[0, 2].set_title("Survival by Passenger Class")
axes[0, 2].legend(title='Survived', labels=['Died', 'Survived'])

# Chart 4: Age Distribution of Survivors
sns.histplot(data=df[df['Survived'] == 1], x='Age', bins=20, kde=True, ax=axes[1, 0])
axes[1, 0].set_title("Age Distribution of Survivors")

# Chart 5: Age Distribution by Class and Sex
sns.boxplot(data=df, x='Pclass', y='Age', hue='Sex', ax=axes[1, 1])
axes[1, 1].set_title("Age by Class & Sex")

# Chart 6: Correlation Heatmap
corr = df[['Survived', 'Pclass', 'Age']].corr()
sns.heatmap(corr, annot=True, cmap='coolwarm', ax=axes[1, 2])
axes[1, 2].set_title("Correlation Heatmap")

# Adjust layout
plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()
