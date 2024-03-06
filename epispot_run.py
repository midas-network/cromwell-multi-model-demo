import sys
from numpy import linspace
from epispot import params
from epispot.pre import seir
# from epispot.plots.web import stacked
from epispot.plots.native import stacked
from epispot.estimates.getters import query
from tabulate import tabulate

# get run-time parameters
start = int(sys.argv[1])
stop = int(sys.argv[2])
num_samples = int(sys.argv[3])
pop_size = sys.argv[4]

# print("start = " + str(start))
# print("stop = " + str(stop))
# print("num_samples = " + str(num_samples))
# print("pop_size = " + pop_size)

# get estimates from literature
paper = 'SARS-CoV-2/Santos 2022/'
beta = query(paper + 'beta')
gamma = query(paper + 'gamma')
delta = query(paper + 'delta')

# define model parameters
R_0 = params.RNaught(gamma=gamma, beta=beta)
N = float(pop_size)

# create a model and solve it
Model = seir(R_0, gamma, N, delta)
Solution = Model.integrate(linspace(start, stop, num_samples))
predicated = Solution[-1]
p_infected = predicated[2]

plot_model = stacked(Model, linspace(start, stop, num_samples), latex=False)
# plot.show()
plot_model.savefig('../results/comp_pop_over_time-'+str(start)+'-'+str(stop)+'-'+str(num_samples)+'-'+pop_size+'.png')
print(tabulate(Solution), file=open('../results/comp_pop_over_time-'+str(start)+'-'+str(stop)+'-'+str(num_samples)+'-'+pop_size+'.txt','a'))
