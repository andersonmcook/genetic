defmodule Genetic.Selection do
  @moduledoc false

  @doc """
  Choose the best `n` chromosomes to reproduce.

  Can lead to premature convergence.
  """
  defdelegate elite(population, n), to: Enum, as: :take

  @doc """
  Choose random chromosomes to reproduce.
  """
  defdelegate random(population, n), to: Enum, as: :take_random

  @doc """
  Choose random chromosomes and select the strongest.
  """
  def tournament(population, n, size) do
    Enum.map(1..n, fn _ ->
      population
      |> Enum.take_random(size)
      |> Enum.max_by(& &1.fitness)
    end)
  end

  def unique_tournament(population, n, size) do
    do_unique_tournament(population, n, size, MapSet.new())
  end

  defp do_unique_tournament(population, n, size, selected) do
    if MapSet.size(selected) == n do
      MapSet.to_list(selected)
    else
      chosen = tournament(population, n, size)
      do_unique_tournament(population, n, size, MapSet.put(selected, chosen))
    end
  end

  def roulette(population, n) do
    sum_fitness = Enum.reduce(population, 0, fn curr, acc -> acc + curr.fitness end)

    Enum.map(1..n, fn _ ->
      u = :rand.uniform() * sum_fitness

      Enum.reduce_while(population, 0, fn curr, acc ->
        if curr.fitness + acc > u do
          {:halt, curr}
        else
          {:cont, curr.fitness + acc}
        end
      end)
    end)
  end
end
