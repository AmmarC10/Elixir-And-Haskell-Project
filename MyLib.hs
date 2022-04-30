module MyLib (main, process, orbitMsg, distanceMsg) where
import Data.List

main :: IO ()
main = do
     contents <- getContents
     putStrLn $ process contents

getWorkingList input = lines input

-- creates 2d array to work with other funtions

getData list = do
     let filtered = filter(\l -> length(words l) == 3) list
     map(\l -> words l) filtered

-- gets data portion of input

toFindOrbits list = filter(\l -> length(words l) == 1) list

-- returns list of planets that orbits need to be found

toFindDistances list = filter(\l -> length(words l) == 2) list

-- returns list of planets that distace between need to be found

noOrbits planet dataOrbits = do
     let check = map(\l -> planet == l !! 2) dataOrbits
     let final = all (==False) check
     final
-- Used in findOrbits to check if the planet has no orbits

findOrbits planet initial dataOrbits orbits = do
     if noOrbits planet dataOrbits || length dataOrbits == 0 then orbits
     else 
          if (head dataOrbits) !! 2 == planet then findOrbits (head dataOrbits !! 0) initial initial (orbits++[head dataOrbits !! 0])
          else findOrbits planet initial (tail dataOrbits) orbits

-- Gets orbits of a planet

orbitMsg input planet = do
     let workingList = getWorkingList input
     let dataOrbits = getData workingList
     let orbits = findOrbits planet dataOrbits dataOrbits []
     if length orbits == 0 then planet ++ " orbits nothing" else planet ++ " orbits " ++ intercalate " " orbits

-- gets the full message of orbits for a planet

findDistance :: String -> String -> [String] -> [String] -> [[String]] -> [[String]] -> [String] -> [String]
findDistance start destination orbits visited initial dataOrbits distance = do
     if start == destination || length dataOrbits == 0 then distance
     else if ((head dataOrbits)!!2) == start && (elem ((head dataOrbits)!!0) orbits) && (not (elem ((head dataOrbits)!!0) visited)) then
          findDistance ((head dataOrbits)!!0) destination orbits (visited++[head dataOrbits!!0]) initial initial (distance++[head dataOrbits!!1])
     else if (head dataOrbits)!!0 == start && (elem ((head dataOrbits)!!2) orbits) && (not (elem ((head dataOrbits)!!2) visited)) then
          findDistance ((head dataOrbits)!!2) destination orbits (visited++[head dataOrbits!!2]) initial initial (distance++[head dataOrbits!!1])
     else findDistance start destination orbits visited initial (tail dataOrbits) distance

-- calculates distance between 2 planets



distanceMsg input planet1 planet2 = do
     let workingList = getWorkingList input
     let dataOrbits = getData workingList
     let orbits1 = findOrbits planet1 dataOrbits dataOrbits []
     let orbits2 = findOrbits planet2 dataOrbits dataOrbits []
     let combined = nub (orbits1 ++ orbits2)
     let distance = findDistance planet2 planet1 combined [] dataOrbits dataOrbits []
     let converted = map (read :: String -> Int) distance
     let final = sum converted
     "From " ++ planet1 ++ " to " ++ planet2 ++ " is " ++ show final ++ "km"

-- returns the final string for the distance between 2 planets

finalOutput :: String -> [[String]] -> [String] -> [String]
finalOutput input list final = 
     if length list == 0 then final
     else if (length (head list)) == 1 then finalOutput input (tail list) final++[orbitMsg input ((head list)!!0)]
     else if (length (head list)) == 2 then finalOutput input (tail list) final++[distanceMsg input ((head list)!!0) ((head list)!!1)]
     else finalOutput input (tail list) final
 
 -- gets final output by recursively going through the input and applying the functions applicable    

process :: String -> String
process input = do
     let workingList = getWorkingList input
     let list = map(\l -> words l) workingList
     let final = finalOutput input list []
     intercalate "\n" (reverse final) ++ "\n"
     


