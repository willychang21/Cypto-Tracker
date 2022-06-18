import UIKit

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    // MARK: Subviews
 
    // Name
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    // Symbol
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    // Price
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // Icon
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size:CGFloat = contentView.height/1.1
        iconImageView.frame = CGRect(
            x: 20,
            y: (contentView.height-size)/2,
            width: size,
            height: size
        )
        
        nameLabel.sizeToFit()
        symbolLabel.sizeToFit()
        priceLabel.sizeToFit()
        
        nameLabel.frame = CGRect(
            x: 30 + size,
            y: 0,
            width: contentView.width/2,
            height: contentView.height/2
        )
        symbolLabel.frame = CGRect(
            x: 30 + size,
            y: contentView.height/2,
            width: contentView.width/2,
            height: contentView.height/2
        )
        priceLabel.frame = CGRect(
            x: contentView.width/2,
            y: 0,
            width: (contentView.width/2)-15,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() { // let every single cell nil itself out in case it's ready to be reused for the next cell so we'll go ahead and nill out the image
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        symbolLabel.text = nil
    }
    
    // MARK: Configure
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        if let data = viewModel.iconData {
            iconImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    fatalError()
                }
                viewModel.iconData = data
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
