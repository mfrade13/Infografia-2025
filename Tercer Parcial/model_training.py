from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import pandas as pd
import joblib

# Cargar dataset
df = pd.read_csv('sign_data.csv')
X = df.drop('label', axis=1)
y = df['label']

# Separar entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Entrenar modelo
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Evaluar
print("Accuracy:", accuracy_score(y_test, model.predict(X_test)))

# Guardar modelo
joblib.dump(model, 'sign_model.pkl')
