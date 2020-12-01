defmodule Genetic.Crossover do
  @moduledoc """
  Crossover is analogous to reproduction.
  Parents will combine to make stronger children.
  """

  alias Genetic.Chromosome

  @doc """
  Simple, but does a poor job producing stronger solutions.
  Won't maintain the integrity of a permutation.
  Most effective on binary genotypes where order matters.
  Only useful for basic problems, prototyping, or benchmarking.
  """
  def single_point(p1, p2) do
    cx_point = :rand.uniform(p1.size)

    {p1_head, p1_tail} = Enum.split(p1.genes, cx_point)
    {p2_head, p2_tail} = Enum.split(p2.genes, cx_point)

    {%{p1 | genes: p1_head ++ p2_tail}, %{p2 | genes: p2_head ++ p1_tail}}
  end

  @doc """
  Preserves the integrity of a permutation solution.
  Produces two new, valid children.
  Can be slow.
  """
  def order_one(p1, p2) do
    limit = Enum.count(p1.genes) - 1
    # Get random range
    {i1, i2} =
      [:rand.uniform(limit), :rand.uniform(limit)]
      |> Enum.sort()
      |> List.to_tuple()

    # p2 contribution
    slice1 = Enum.slice(p1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    p2_contribution = Enum.reject(p2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(p2_contribution, i1)

    # p1 contribution
    slice2 = Enum.slice(p1.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    p1_contribution = Enum.reject(p1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(p1_contribution, i1)

    # Make and return
    {c1, c2} = {head1 ++ slice1 ++ tail1, head2 ++ slice2 ++ tail2}
    {%{p1 | genes: c1}, %{p2 | genes: c2}}
  end

  @doc """
  Doesn't work on permutations.
  Can be slow with large chromosomes.
  Works best with binary genotypes.
  """
  def uniform(p1, p2, rate \\ 0.5) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        if :rand.uniform() < rate do
          {x, y}
        else
          {y, x}
        end
      end)
      |> Enum.unzip()

    # Do I need to recalculate size?
    # {%{p1 | genes: c1, size: length(c1)}, %{p2 | genes: c2, size: length(c2)}}
    {%{p1 | genes: c1}, %{p2 | genes: c2}}
  end

  @doc """
  z = x * a + y * (1 - a)
  Works for real-value chromosomes.
  Tends to converge quickly on poor solutions due to lack of randomness.
  """
  def whole_arithmetic(p1, p2, alpha \\ 0.5) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        {x * alpha + y * (1 - alpha), x * (1 - alpha) + y * alpha}
      end)
      |> Enum.unzip()

    {%{p1 | genes: c1}, %{p2 | genes: c2}}
  end
end
