//
//  ViewController.swift
//  DiffableBugRepro
//
//  Created by Rafael Nobre on 20/09/22.
//

import UIKit
import DiffableDataSources

typealias NSDiffableDataSourceSnapshot = DiffableDataSourceSnapshot
typealias UICollectionViewDiffableDataSource = CollectionViewDiffableDataSource
typealias UITableViewDiffableDataSource = TableViewDiffableDataSource

struct MyModel{
    let id:String
    let name:String
}

enum Section:Hashable{
    case results
}

struct MyDiffableItem:Hashable{
    let model:MyModel
    let isFavorite:Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(model.id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.model.id == rhs.model.id && lhs.isFavorite == rhs.isFavorite
    }
}

class ViewController: UIViewController, UICollectionViewDelegate {

    let state1:[MyModel] = [
            .init(id: "com.t.rps", name: "Rock Paper Scissor"),
            .init(id: "com.t.minigolf", name: "Mini Golf"),
            .init(id: "com.t.dng", name: "Draw and Guess!"),
            .init(id: "com.t.anim.alphabet", name: "Alphabet Order"),
            .init(id: "com.t.arcademics", name: "Multiplication Race"),
            .init(id: "com.t.arcademics.canoepuppies", name: "Canoe Puppies"),
            .init(id: "com.t.arcademics.islandchase", name: "Island Substraction"),
            .init(id: "com.t.arcademics.jchicks", name: "Jumping Chicks"),
            .init(id: "com.t.city_builder", name: "City Builder"),
            .init(id: "com.t.wordsearch", name: "Word Search"),
            .init(id: "com.t.animate.dragndrop", name: "TEST CC"),
            .init(id: "com.t.arcade_golf", name: "Golf"),
            .init(id: "com.t.backgammon", name: "Backgammon"),
            .init(id: "com.t.battleships", name: "Battleships"),
            .init(id: "com.t.blockspuzzle", name: "Block Puzzle"),
            .init(id: "com.t.bowling", name: "Bowling"),
            .init(id: "com.t.carrush", name: "Car Rush"),
            .init(id: "com.t.checkers", name: "Checkers"),
            .init(id: "com.t.chess", name: "Chess"),
            .init(id: "com.t.connect4", name: "Straight 4"),
            .init(id: "com.t.cooking", name: "Pizza Chef!"),
            .init(id: "com.t.darts", name: "Arcade Darts"),
            .init(id: "com.t.decorate", name: "Decorate Christmas"),
            .init(id: "com.t.decorate.space", name: "Decorate Space"),
            .init(id: "com.t.decorate.themes", name: "Decorate!"),
            .init(id: "com.t.fourcolors", name: "Four Colors"),
            .init(id: "com.t.frog_math", name: "Frog Math"),
            .init(id: "com.t.guesswho", name: "Guess The Person!"),
            .init(id: "com.t.matchgenius", name: "Match Genius!"),
            .init(id: "com.t.musictogether", name: "Music Together"),
            .init(id: "com.t.penaltykicks", name: "Penalty Kicks"),
            .init(id: "com.t.reversi", name: "Reversi"),
            .init(id: "com.t.snakesandladders", name: "Chutes & Ladders"),
            .init(id: "com.t.soda", name: "Soda Plumber"),
            .init(id: "com.t.spotDifferences", name: "Spot the Differences"),
            .init(id: "com.t.swipe_basketball", name: "Basketball"),
            .init(id: "com.t.videostogether", name: "Videos Together"),
            .init(id: "com.t.yacht", name: "Yacht Dice Game"),
            .init(id: "com.t.memory", name: "Memory Themes"),
            .init(id: "com.t.findobject", name: "Search & Find"),
            .init(id: "com.t.bingogame", name: "Bingo Game"),
            .init(id: "com.t.tweens", name: "2 of the same"),
            .init(id: "com.t.tictactoe", name: "Tic Tac Toe"),
            .init(id: "com.t.racing_game", name: "Race Time"),
            .init(id: "com.t.pacrat", name: "PacRat"),
            .init(id: "com.t.pacrat.together", name: "PacRat Together")
            ]

    let state2:[MyModel] = [
        .init(id: "com.t.matchgenius", name: "Match Genius!"),
        .init(id: "com.t.musictogether", name: "Music Together"),
        .init(id: "com.t.simplememory", name: "Memory Game"),
        .init(id: "com.t.findobject", name: "Search & Find"),
        .init(id: "com.t.bingogame", name: "Bingo Game"),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.applySnapshot(state1, animated: false)
        self.navigationItem.rightBarButtonItem = .init(title: "Filter", style: .plain, target: self, action: #selector(switchState))
    }

    @objc private func switchState(){
        self.applySnapshot(self.models.count == state1.count ? state2 : state1, animated: true)
    }

    func applySnapshot(_ state: [MyModel], animated:Bool){
        self.models = state
        var snapshot = NSDiffableDataSourceSnapshot<Section, MyDiffableItem>()
        snapshot.appendSections([.results])
        snapshot.appendItems(state.map { .init(model: $0, isFavorite: Bool.random())})

        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    override func loadView() {
        view = self.collectionView
    }

    var models:[MyModel] = []

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.register(MyCell.self, forCellWithReuseIdentifier: "myCell")
        view.delegate = self
        return view
    }()

    private lazy var collectionViewLayout:UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }()

    lazy var dataSource:UICollectionViewDiffableDataSource<Section, MyDiffableItem> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, MyDiffableItem>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, _ in
            let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: "myCell",
              for: indexPath) as! MyCell
            guard !self.models.isEmpty,
                  let index = self.models.index(
                    self.models.startIndex,
                    offsetBy: indexPath.item,
                    limitedBy: self.models.index(before: self.models.endIndex)
                  )
            else { return cell }
            let model = self.models[index]

            cell.configure(with: model)

            return cell
        })
        return dataSource
    }()

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models[indexPath.item]

        print("Selected model \(model)")
    }


}

class MyCell:UICollectionViewCell{
    private lazy var label:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model:MyModel){
        label.text = model.name
    }
}
