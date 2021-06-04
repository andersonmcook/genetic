defmodule Genetic.Mutation do
  @moduledoc false

  # Only applies to binary genotypes
  def flip(genes) do
    Enum.map(genes, &Bitwise.bxor(&1, 1))
  end

  def gaussian(genes) do
    length = length(genes)

    mean =
      genes
      |> Enum.sum()
      |> Kernel./(length)

    variance =
      genes
      |> Enum.reduce(0, &sum_variance(&1, &2, mean))
      |> Kernel./(length)

    Enum.map(genes, fn _ -> :rand.normal(mean, variance) end)
  end

  defp sum_variance(gene, sum, mean) do
    :math.pow(mean - gene, 2) + sum
  end

  defdelegate scramble(genes), to: Enum, as: :shuffle
end
