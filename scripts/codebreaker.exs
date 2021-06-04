defmodule Codebreaker do
  @moduledoc false

  @behaviour Genetic.Problem

  use Bitwise

  alias Genetic.{Chromosome, Genotype, Problem}

  @encrypted 'LIjs`B`k`qlfDibjwlqmhv'
  @target "ILoveGeneticAlgorithms"

  @impl Problem
  def genotype do
    %Chromosome{genes: Genotype.binary(64), size: 64}
  end

  @impl Problem
  def fitness_function(chromosome) do
    key =
      chromosome.genes
      |> Enum.map_join(&Integer.to_string/1)
      |> String.to_integer(2)

    guess =
      @encrypted
      |> cipher(key)
      |> List.to_string()

    String.jaro_distance(@target, guess)
  end

  defp cipher(word, key) do
    Enum.map(word, &(&1 |> Bitwise.bxor(key) |> rem(32768)))
  end

  @impl Problem
  def terminate?(population, generation) do
    Enum.max_by(population, &fitness_function/1).fitness == 1
  end
end

Codebreaker
|> Genetic.run()
|> Map.fetch!(:genes)
|> Enum.map_join(&Integer.to_string/1)
|> Integer.parse(2)
|> IO.inspect(label: "key")
