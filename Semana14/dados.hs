import System.Random (randomR, mkStdGen)
main = do
    let
        h1 = fst ((randomR (1,6), (mkStdGen 123253676634654)))
        h2 = fst ((randomR (1,6), (mkStdGen (snd h1))))
        h3 = fst ((randomR (1,6), (mkStdGen (snd h2))))
    putStrLn $ show h1
    putStrLn $ show h2
    putStrLn $ show h3