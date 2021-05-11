defmodule Speller do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @size 34
  @target "supercalifragilisticexpialidocious"

  @impl true
  def genotype do
    %Chromosome{
      genes:
        fn -> Enum.random(?a..?z) end
        |> Stream.repeatedly()
        |> Enum.take(@size),
      size: @size
    }
  end

  @impl true
  def fitness_function(chromosome) do
    String.jaro_distance(@target, List.to_string(chromosome.genes))
  end

  @impl true
  def terminate?([best | _], generation) do
    # As the target grows, so does the generations needed to find the best fit
    # A 7 character string already takes more than 1000 generations.
    best.fitness === 1.0 or generation == 1000
  end
end

Speller
|> Genetic.run()
|> IO.inspect()
