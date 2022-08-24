import scipy.io
import phenograph
mat = scipy.io.loadmat('../CellIntensityMatrices_Subsampled/Group_BRM_subsampled.mat');
data = mat['A']
data = data['Y']
data = data[0]
communities, graph, Q = phenograph.cluster(data[0], k=70)
scipy.io.savemat('Group_BRM_subsampled.mat', {'Y': communities, 'graph': graph, 'Q':Q})