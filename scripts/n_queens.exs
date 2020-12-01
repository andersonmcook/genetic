defmodule NQueens do
  @moduledoc false

  @behaviour Genetic.Problem

  alias Genetic.Chromosome

  @range 0..7
  @size 8

  @impl true
  def genotype do
    %Chromosome{genes: Enum.shuffle(@range), size: @size}
  end

  @impl true
  def fitness_function(chromosome) do
    diagonal_clash_sum =
      for i <- @range, j <- @range, reduce: 0 do
        acc ->
          acc +
            if i == j do
              0
            else
              dx = abs(i - j)
              dy = abs(Enum.at(chromosome.genes, i) - Enum.at(chromosome.genes, j))
              if dx == dy, do: 1, else: 0
            end
      end

    unique_length =
      chromosome.genes
      |> Enum.uniq()
      |> length()

    unique_length - diagonal_clash_sum
  end

  @impl true
  def terminate?(population, _generation) do
    Enum.max_by(population, &fitness_function/1).fitness == @size
  end
end

NQueens
|> Genetic.run(crossover_type: &Genetic.Crossover.order_one/2)
|> IO.inspect()
