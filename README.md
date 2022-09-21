This aims to reproduce a bug when applying an specific data set to a collection view using DiffableDataSources.
It's a simple list of game titles that are rendered on a trivial collection view compositional layouts through a diffable data source.
Tapping the rightNavigationItem, you can switch between the data states that trigger the problem. You can see some items get duplicated, and some of the snapshot indexes do not match the actual source array 
on state2 (filtered).
At the top of the ViewController.swift file, if you comment out the typealias'es to use the original Apple implementation and run again, the error no longer occurs.
