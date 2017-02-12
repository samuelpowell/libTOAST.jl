# TOAST.jl: interface to the TOAST++ library
# Copyright (C) 2017 Samuel Powell

@testset "CoeffTypes" begin

  mesh = Mesh(joinpath(meshdir_2D, "circle25_32.msh"));
  vtx,  = data(mesh)
  nprm = sin(5*vtx[:,1]./15) + cos(4*vtx[:,2]./15)

  nx, ny = 250, 250
  pixelmap = PixelMap(mesh, (nx,ny))

  nc0 = NodalCoeff(mesh, nprm)

  sc1 = SolutionCoeff(pixelmap, nc0)
  gc1 = IntermediateCoeff(pixelmap, nc0)
  bc1 = RasterCoeff(pixelmap, nc0)

  nc1 = NodalCoeff(bc1)
  nc2 = NodalCoeff(sc1)
  nc3 = NodalCoeff(gc1)

  sc2 = SolutionCoeff(gc1)
  sc3 = SolutionCoeff(bc1)

  gc2 = IntermediateCoeff(sc1)
  gc3 = IntermediateCoeff(bc1)

  bc2 = RasterCoeff(sc1)
  bc3 = RasterCoeff(gc1)

  maperr(c1, c2) = 100*norm(c2.-c1)./norm(c1)
  maptol = .5

  # Tset functions on the mesh
  @test maperr(nc0,nc1) < maptol
  @test maperr(nc0,nc2) < maptol
  @test maperr(nc0,nc3) < maptol

  # Test functions in the raster
  @test maperr(bc1,bc2) < maptol
  @test maperr(bc1,bc3) < maptol

  # Test functions in the solution
  @test maperr(sc1,sc2) < maptol
  @test maperr(sc1,sc3) < maptol

  # Test functions in the intermediate
  @test maperr(gc1,gc2) < maptol
  @test maperr(gc1,gc3) < maptol

end
