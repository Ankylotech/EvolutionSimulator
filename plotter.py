import matplotlib.pyplot as plt
from ast import literal_eval as make_tuple
import numpy as np
myarray = np.fromfile('saveDataIndex.dat',dtype=float)
myIndex = 0
for x in myarray:
    myIndex += x
x = []
y = []
with open("C:\\Users\\Anky\Desktop\\Programmieren\\Processing\\EvoSim\\ältestesLw%s.txt"% myIndex) as ältestes:
    data = ältestes.read().split(";")
    data.pop(-1)
    for i in data:
        x.append(make_tuple(i)[0])
        y.append(make_tuple(i)[1])
    plt.plot(x,y)
    plt.show()
x = []
y = []
with open("C:\\Users\\Anky\Desktop\\Programmieren\\Processing\\EvoSim\\durchschnittsLw%s.txt"% myIndex) as ältestes:
    data = ältestes.read().split(";")
    data.pop(-1)
    for i in data:
        x.append(make_tuple(i)[0])
        y.append(make_tuple(i)[1])
    plt.plot(x,y)
    plt.show()
x = []
y = []
with open("C:\\Users\\Anky\Desktop\\Programmieren\\Processing\\EvoSim\\staerkeLw%s.txt"% myIndex) as ältestes:
    data = ältestes.read().split(";")
    data.pop(-1)
    for i in data:
        x.append(make_tuple(i)[0])
        y.append(make_tuple(i)[1])
    plt.plot(x,y)
    plt.show()

