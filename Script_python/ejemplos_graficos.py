import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# # data
# x = [1,2,3,4,5,6,7,8,9]
# colors = plt.get_cmap('Blues')(np.linspace(0.2, 0.7, len(x) ))
# x1 = 0.5 + np.arange(8)
# y1 = [4.8, 5.5, 3.5, 4.6, 6.5, 6.6, 2.6, 3.0]
# # plot
# fig, ax = plt.subplots()
# ax.pie(y1, colors=colors, radius=3, center=(4, 4),
#        wedgeprops={"linewidth": 1, "edgecolor": "white"}, frame=True)

# ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))

# fig, ax2 = plt.subplots()
# ax2.bar(x1, y1, width=1, edgecolor="white", linewidth=0.7)

# ax2.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))

np.random.seed(3)
x = 4 + np.random.normal(0, 2, 24)
y = 4 + np.random.normal(0, 2, len(x))
# size and color:
sizes = np.random.uniform(15, 80, len(x))
colors = np.random.uniform(15, 80, len(x))

# # plot
# fig, ax = plt.subplots()

# ax.scatter(x, y, s=sizes, c=colors, vmin=0, vmax=100)

# ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))


# # make data
# x = np.linspace(0, 10, 100)
# y = 4 + 2 * np.sin(2 * x)

# # plot
# # fig, ax = plt.subplots()

# ax.plot(x, y, linewidth=2.0)

# ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))


# # make data
# x = np.arange(0, 10, 2)
# ay = [1, 1.25, 2, 2.75, 3]
# by = [1, 1, 1, 1, 1]
# cy = [2, 1, 2, 1, 2]
# y = np.vstack([ay, by, cy])

# # plot
# fig, ax = plt.subplots()

# ax.stackplot(x, y)

# ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))


# # make data
# y = [4.8, 5.5, 3.5, 4.6, 6.5, 6.6, 2.6, 3.0]

# # plot
# fig, ax = plt.subplots()

# ax.stairs(y, linewidth=2.5)

# ax.set(xlim=(0, 8), xticks=np.arange(1, 8),
#        ylim=(0, 8), yticks=np.arange(1, 8))

# plt.show()

df = pd.DataFrame(np.random.random((5,5)), columns = ["Messi", "Di maria", "De Paul", "Alvarez", "Dibu"  ])
plt.figure(figsize=(12,8))
sns.heatmap(df)
plt.legend()
plt.show()
