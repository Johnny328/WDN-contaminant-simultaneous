model = epanet_reader4_extract('bangalore_expanded221.inp')
J = zeros(model.pipes.npipes,model.nodes.ntot)
J()