import UIKit

protocol HeaderViewDelegate: class {
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
  let config: LightboxConfig

  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: config.closeButton.text,
      attributes: config.closeButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: UIControl.State())

    if let size = config.closeButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = config.closeButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !config.closeButton.enabled

    return button
  }()

  open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: config.deleteButton.text,
      attributes: config.deleteButton.textAttributes)

    let button = UIButton(type: .system)

    button.setAttributedTitle(title, for: .normal)

    if let size = config.deleteButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = config.deleteButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !config.deleteButton.enabled

    return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init(config: LightboxConfig) {
    self.config = config
    
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [closeButton, deleteButton].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressDeleteButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    closeButton.frame.origin = CGPoint(
      x: bounds.width - closeButton.frame.width - 17,
      y: topPadding
    )

    deleteButton.frame.origin = CGPoint(
      x: 17,
      y: topPadding
    )
  }
}
