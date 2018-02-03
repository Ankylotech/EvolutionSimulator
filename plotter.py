import matplotlib.pyplot as plt
from ast import literal_eval as make_tuple

x = []
y = []
with open("C:\\Users\\Anky\Desktop\\Programmieren\\Processing\\EvoSim\\durchschnittsLw1.txt") as ältestes:
    data = ältestes.read().split(";")
    data.pop(-1)
    for i in data:
        x.append(make_tuple(i)[0])
        y.append(make_tuple(i)[1])
    plt.plot(x,y)
    plt.show()
