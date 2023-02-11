#!/usr/bin/env julia

# file "bootSNaQ.jl". run in the shell like this in general:
# julia bootSNaQ.jl seed

length(ARGS) > 0 ||
    error("need 1 argument: seed number")
seed = parse(Int, ARGS[1])
outputfile = string("analyses/phylonetworks/snaq/bootstrap/net2_subset1_boot", seed) # example: "net1_subset1_boot193476"
@info "will run bootSNaQ with seed=$seed, output will go to: $outputfile"

# load all cores
using Distributed
addprocs(5)
# load needed packages
using DataFrames, CSV
@everywhere using PhyloNetworks
# load CF table from BUCKy with confidence intervals
df = DataFrame!(CSV.File("analyses/phylonetworks/snaq/CFtable.csv"))
# load binary tree to use as starting topology
net0 = readMultiTopology("analyses/phylonetworks/snaq/net0.out")[1]
# load network with h=2
net2 = readMultiTopology("analyses/phylonetworks/snaq/net2.out")[1]
# Perform 100 bootstrap replicate searches with h=2. Do 20 optimization runs for each
# replicate: 10 starting from the net0 tree and 10 starting from the net2 network
bootsnaq(net0, df, hmax=2, nrep=1, runs=20, filename=outputfile, seed=seed, otherNet=net2, prcnet=0.5)