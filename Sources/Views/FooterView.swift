import UIKit

public protocol FooterViewDelegate: class {

  func footerView(_ footerView: FooterView, didExpand expanded: Bool)
}

open class FooterView: UIView {
  let config: LightboxConfig

  open fileprivate(set) lazy var infoLabel: InfoLabel = { [unowned self] in
    let label = InfoLabel(text: "", config: config.infoLabel)
    label.isHidden = !config.infoLabel.enabled

    label.textColor = config.infoLabel.textColor
    label.isUserInteractionEnabled = true
    label.delegate = self

    return label
  }()

  open fileprivate(set) lazy var pageLabel: UILabel = { [unowned self] in
    let label = UILabel(frame: CGRect.zero)
    label.isHidden = !config.pageIndicator.enabled
    label.numberOfLines = 1

    return label
  }()

  open fileprivate(set) lazy var separatorView: UIView = { [unowned self] in
    let view = UILabel(frame: CGRect.zero)
    view.isHidden = !config.pageIndicator.enabled
    view.backgroundColor = config.pageIndicator.separatorColor

    return view
  }()

  let gradientColors = [UIColor(white: 4/255, alpha: 0.1), UIColor(white: 4/255, alpha: 1)]
  open weak var delegate: FooterViewDelegate?

  // MARK: - Initializers

  public init(config: LightboxConfig) {
    self.config = config

    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear
    _ = addGradientLayer(gradientColors)

    [pageLabel, infoLabel, separatorView].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helpers

  func expand(_ expand: Bool) {
    expand ? infoLabel.expand() : infoLabel.collapse()
  }

  func updatePage(_ page: Int, _ numberOfPages: Int) {
    let text = "\(page)/\(numberOfPages)"

    pageLabel.attributedText = NSAttributedString(string: text,
                                                  attributes: config.pageIndicator.textAttributes)
    pageLabel.sizeToFit()
  }

  func updateText(_ text: String) {
    infoLabel.fullText = text

    if text.isEmpty {
      _ = removeGradientLayer()
    } else if !infoLabel.expanded {
      _ = addGradientLayer(gradientColors)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    do {
      let bottomPadding: CGFloat
      if #available(iOS 11, *) {
        bottomPadding = safeAreaInsets.bottom
      } else {
        bottomPadding = 0
      }

      pageLabel.frame.origin = CGPoint(
        x: (frame.width - pageLabel.frame.width) / 2,
        y: frame.height - pageLabel.frame.height - 2 - bottomPadding
      )
    }

    separatorView.frame = CGRect(
      x: 0,
      y: pageLabel.frame.minY - 2.5,
      width: frame.width,
      height: 0.5
    )

    infoLabel.frame.origin.y = separatorView.frame.minY - infoLabel.frame.height - 15

    resizeGradientLayer()
  }
}

// MARK: - LayoutConfigurable

extension FooterView: LayoutConfigurable {

  @objc public func configureLayout() {
    infoLabel.frame = CGRect(x: 17, y: 0, width: frame.width - 17 * 2, height: 35)
    infoLabel.configureLayout()
  }
}

extension FooterView: InfoLabelDelegate {

  public func infoLabel(_ infoLabel: InfoLabel, didExpand expanded: Bool) {
    _ = (expanded || infoLabel.fullText.isEmpty) ? removeGradientLayer() : addGradientLayer(gradientColors)
    delegate?.footerView(self, didExpand: expanded)
  }
}
