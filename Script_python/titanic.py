import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load dataset
df = pd.read_csv('train.csv')

# Drop rows with missing values in critical columns
df = df.dropna(subset=['Survived', 'Pclass', 'Sex', 'Age'])

# Convert 'Sex' to categorical values
df['Sex'] = df['Sex'].astype('category')

# Basic statistics
print(df.describe())
print(df['Survived'].value_counts())

# Survival count plot
sns.countplot(data=df, x='Survived')
plt.title("Survival Count")
plt.xticks([0, 1], ['Died', 'Survived'])
plt.show()

# Survival by Sex
sns.countplot(data=df, x='Sex', hue='Survived')
plt.title("Survival by Sex")
plt.xticks([0, 1], ['Female', 'Male'])
plt.legend(['Died', 'Survived'])
plt.show()

# Survival by Passenger Class
sns.countplot(data=df, x='Pclass', hue='Survived')
plt.title("Survival by Passenger Class")
plt.legend(['Died', 'Survived'])
plt.show()

# Age distribution of survivors
sns.histplot(data=df[df['Survived'] == 1], x='Age', bins=20, kde=True)
plt.title("Age Distribution of Survivors")
plt.show()

# Age distribution by class and sex
sns.boxplot(data=df, x='Pclass', y='Age', hue='Sex')
plt.title("Age Distribution by Class and Sex")
plt.show()

# Correlation heatmap
corr = df[['Survived', 'Pclass', 'Age']].corr()
sns.heatmap(corr, annot=True, cmap='coolwarm')
plt.title("Correlation Heatmap")
plt.show()

