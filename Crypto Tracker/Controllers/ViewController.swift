import UIKit

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CryptoTableViewCell.self,
                       forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return table
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]()
    private let moneyFormatter = NumberFormatter.moneyFormatter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crypto Tracker"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        APICaller.shared.getAllCryptoData { [weak self] result in
            guard let strongSelf = self else {
                return   
            }
            switch result {
            case .success(let models):
                self?.viewModels = models.compactMap({ crypto in
                    // NumberFormatter
                    let price = crypto.price_usd ?? 0
                    let formatter = strongSelf.moneyFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    let iconUrl = URL(
                        string:
                            APICaller.shared.icons.filter { icon in
                                icon.asset_id == crypto.asset_id
                            }.first?.url ?? ""
                    )
                    
                    return CryptoTableViewCellViewModel(
                        name: crypto.name ?? "N/A",
                        symbol: crypto.asset_id,
                        price: priceString ?? "N/A",
                        iconUrl: iconUrl
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
