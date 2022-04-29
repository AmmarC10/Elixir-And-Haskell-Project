defmodule A2 do
  @moduledoc """
  Documentation for `A2`.
  """

  @doc """
  Assignment 2 - Orbits

  """

  def cleanup(list) do
    list = List.flatten(list)
    Enum.filter(list, &(!is_nil(&1)))
  end

  # cleans up list, changes 2d to 1d and removes any nil values

  def getWorkingList(string) do
    split = String.split(string, "\n")

    split =
      Enum.map(split, fn item ->
        String.split(item, " ")
      end)

    Enum.drop(split, -1)
  end

  # creates a 2D list that will be used from now on to work with the input string

  def getData(list) do
    data = Enum.filter(list, fn item -> Enum.count(item) == 3 end)
    data
  end

  # returns a list of only the data that is used to calculate distances and find orbits

  def findOrbits(data, planet, orbits) do
    check =
      Enum.map(data, fn list ->
        planet === Enum.at(list, 2)
      end)

    check = Enum.any?(check)

    if check do
      Enum.map(data, fn list ->
        if planet === Enum.at(list, 2) do
          findOrbits(data, Enum.at(list, 0), orbits ++ [Enum.at(list, 0)])
        end
      end)
    else
      orbits
    end
  end

  # returns the orbits of the required planet

  def orbitsMsg(list) do
    if length(list) == 1 do
      "#{Enum.at(list, 0)} orbits nothing"
    else
      "#{Enum.at(list, 0)} orbits #{Enum.join(Enum.drop(list, 1), " ")}"
    end
  end

  # returns a string of what the given planet orbits

  def findAllOrbits(planets, data) do
    Enum.map(planets, fn item ->
      findOrbits(data, item, [item]) |> cleanup |> orbitsMsg
    end)
    |> Enum.join("\n")
  end

  # returns an array of messages of the orbits for all planets given in the first parameter array

  def toFindOrbit(list) do
    Enum.filter(list, fn item -> Enum.count(item) == 1 end) |> cleanup
  end

  # returns a list of of all planets whos orbits need to be found

  def orbits(input) do
    workingList = getWorkingList(input)
    data = getData(workingList)
    toFindOrbits = toFindOrbit(workingList)
    findAllOrbits(toFindOrbits, data)
  end

  # calls orbit calculation functions together to get orbits, used for testing

  def combinedOrbits(planet1, planet2, data) do
    startOrbits = findOrbits(data, planet1, []) |> cleanup
    destinationOrbits = findOrbits(data, planet2, []) |> cleanup
    startOrbits ++ destinationOrbits
  end

  def findDistance(start, destination, distance, combinedOrbits, visited, data) do
    if start == destination do
      distance
    else
      Enum.map(data, fn list ->
        if Enum.at(list, 0) == start and Enum.member?(combinedOrbits, Enum.at(list, 2)) and
             not Enum.member?(visited, Enum.at(list, 2)) do
          findDistance(
            Enum.at(list, 2),
            destination,
            distance ++ [Enum.at(list, 1)],
            combinedOrbits,
            visited ++ [Enum.at(list, 2)],
            data
          )
        end

        if Enum.at(list, 2) == start and Enum.member?(combinedOrbits, Enum.at(list, 0)) and
             not Enum.member?(visited, Enum.at(list, 0)) do
          findDistance(
            Enum.at(list, 0),
            destination,
            distance ++ [Enum.at(list, 1)],
            combinedOrbits,
            visited ++ [Enum.at(list, 0)],
            data
          )
        end
      end)
      |> cleanup
    end
  end

  # gets the distance between two planets, doesnt work because distance gets set back to empty if chain is longer than 1 planet

  def distanceMsg(planet1, planet2, data) do
    combined = combinedOrbits(planet1, planet2, data)
    distance = findDistance(planet2, planet1, [], combined, [], data)
    "From #{planet1} to #{planet2} is #{Enum.at(distance, 0)}km"
  end

  def toFind(list) do
    Enum.filter(list, fn item -> Enum.count(item) == 2 or Enum.count(item) == 1 end)
  end

  def process(input) do
    workingList = getWorkingList(input)
    data = getData(workingList)
    find = toFind(workingList)

    Enum.map(find, fn list ->
      if Enum.count(list) == 2 do
        distanceMsg(Enum.at(list, 0), Enum.at(list, 1), data)
      else
        findOrbits(data, Enum.at(list, 0), []) |> cleanup |> orbitsMsg()
      end
    end)
    |> Enum.join("\n")
  end

  def main() do
    File.read!('../sample-input')
    |> process()
  end
end
