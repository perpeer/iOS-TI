//
//  GistsViewController.swift
//  MobvenIOSTI
//
//  Created by Burak Yılmaz on 9.09.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import UIKit

import UIKit

protocol GistsDisplayLogic: class {
    func displayGists(viewModel: Gists.Fetch.ViewModel)
    func displayShowDetail(viewModel: Gists.ShowDetail.ViewModel)
}

final class GistsViewController: UIViewController {
    
    var interactor: GistsBusinessLogic?
    var router: (GistsRoutingLogic & GistsDataPassing)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var gists: [Gists.Fetch.ViewModel.Gist] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = GistsInteractor()
        let presenter = GistsPresenter()
        let router = GistsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchGists(request: Gists.Fetch.Request())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        VersionConfig.shared?.show()
    }
    
}

extension GistsViewController: GistsDisplayLogic {
    
    func displayGists(viewModel: Gists.Fetch.ViewModel) {
        self.gists = viewModel.gists
        tableView.reloadData()
    }
    
    func displayShowDetail(viewModel: Gists.ShowDetail.ViewModel) {
        router?.routeToGistDetails(delegate: self)
    }
    
}

extension GistsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "GistTableViewCell", for: indexPath
        ) as? GistTableViewCell else {
            fatalError("Could not find cell")
        }
        cell.set(gist: gists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.fetchShowDetail(
            request: Gists.ShowDetail.Request(index: indexPath.row)
        )
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension GistsViewController: GistDetailFavoriteDelegate {
    func gistDetailFavoriteUpdatedGist(_ gist: Gist) {
        if let index = gists.firstIndex(where: {$0.id == gist.id}) {
            gists[index].isFavorite = gist.isFavorite
        }
        interactor?.updateGist(gist)
        tableView.reloadData()
    }
}
