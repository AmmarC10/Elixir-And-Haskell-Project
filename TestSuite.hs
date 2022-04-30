module Main where
    import Test.HUnit
    import qualified MyLib
    import qualified System.Exit as Exit

    main = do
         status <- runTestTT tests
         if failures status > 0 then Exit.exitFailure else return ()
-- run tests with:
--     cabal test

    solarSystem = "Sun 57909227 Mercury\n\
                    \Earth 384400 Moon\n\
                    \Sun 149598262 Earth\n\
                    \Moon 1757 LROrbiter\n\
                    \Mars 9376 Phobos\n\
                    \Mars 23458 Deimos\n\
                    \Sun 227943824 Mars\n\
                    \Sun 778340821 Jupiter\n\
                    \Sun 1426666422 Saturn\n\
                    \Sun 2870658186 Uranus\n\
                    \Sun 4498396441 Neptune\n"
-- here are some standard tests
-- you should augment them with your own tests for development purposes
    process = MyLib.process
    tests = test [
      "direct distance" ~:
          "From Earth to Sun is 149598262km\n" ~=? process "Sun 149598262 Earth\nEarth Sun\n"
      ,"direct orbit" ~:
          "Earth orbits Sun\n" ~=? process "Sun 149598262 Earth\nEarth\n"
      ,"solar system1" ~:
          "From Sun to Moon is 149982662km\n\
          \From Deimos to Moon is 377949944km\n\
          \Deimos orbits Mars Sun\n\
          \From Deimos to Phobos is 32834km\n\
          \Moon orbits Earth Sun\n\
          \LROrbiter orbits Moon Earth Sun\n" ~=? process (solarSystem ++ "Sun Moon\n\
                    \Deimos Moon\n\
                    \Deimos\n\
                    \Deimos Phobos\n\
                    \Moon\n\
                    \LROrbiter\n")
      ,"solar system2" ~:
          "From LROrbiter to Deimos is 377951701km\n" ~=? process (solarSystem ++ "LROrbiter Deimos\n")
      ,"orbitMsg test for no orbits" ~:
          "Sun orbits nothing" ~=? MyLib.orbitMsg (solarSystem) "Sun"
      ,"orbitMsg test for one orbit" ~:
          "Neptune orbits Sun" ~=? MyLib.orbitMsg (solarSystem) "Neptune"
      ,"orbitMsg test for >1 orbits" ~:
          "LROrbiter orbits Moon Earth Sun" ~=? MyLib.orbitMsg (solarSystem) "LROrbiter"
      ,"distanceMsg test for direct" ~:
          "From Sun to Jupiter is 778340821km" ~=? MyLib.distanceMsg (solarSystem) "Sun" "Jupiter"
      ,"distanceMsg test for indirect" ~:
          "From Sun to Moon is 149982662km" ~=? MyLib.distanceMsg (solarSystem) "Sun" "Moon"
      ]
