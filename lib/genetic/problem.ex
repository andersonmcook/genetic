defmodule Genetic.Problem do
  @moduledoc false

  alias Genetic.Chromosome

  @callback fitness_function(Chromosome.t()) :: number
  @callback genotype :: Chromosome.t()
  @callback terminate?(population :: Enumerable.t(), generation :: non_neg_integer) :: boolean
end
