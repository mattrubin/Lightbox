import UIKit
import AVKit
import AVFoundation

public struct LightboxConfig {
  public static var `default` = LightboxConfig()

  /// Whether to show status bar while Lightbox is presented
  public var hideStatusBar = true

  /// Provide a closure to handle selected video
  public var handleVideo: (_ from: UIViewController, _ videoURL: URL) -> Void = { from, videoURL in
    let videoController = AVPlayerViewController()
    videoController.player = AVPlayer(url: videoURL)

    from.present(videoController, animated: true) {
      videoController.player?.play()
    }
  }

  /// How to load image onto UIImageView
  public var loadImage: (UIImageView, URL, ((UIImage?) -> Void)?) -> Void = { (imageView, imageURL, completion) in

    // Use Imaginary by default
    imageView.setImage(url: imageURL, completion: { result in
      switch result {
      case .value(let image):
        completion?(image)
      case .error:
        completion?(nil)
      }
    })
  }

  /// Indicator is used to show while image is being fetched
  public var makeLoadingIndicator: () -> UIView = {
    return LoadingIndicator()
  }

  /// Number of images to preload.
  ///
  /// 0 - Preload all images (default).
  public var preload = 0

  public var pageIndicator = PageIndicator()
  public struct PageIndicator {
    public var enabled = true
    public var separatorColor = UIColor(red: 61/255, green: 71/255, blue: 87/255, alpha: 1)

    public var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(red: 137/255, green: 154/255, blue: 184/255, alpha: 1),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public var closeButton = CloseButton()
  public struct CloseButton {
    public var enabled = true
    public var size: CGSize?
    public var text = NSLocalizedString("Close", comment: "")
    public var image: UIImage?

    public var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor.white,
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public var deleteButton = DeleteButton()
  public struct DeleteButton {
    public var enabled = false
    public var size: CGSize?
    public var text = NSLocalizedString("Delete", comment: "")
    public var image: UIImage?

    public var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 16),
      .foregroundColor: UIColor(red: 250/255, green: 47/255, blue: 91/255, alpha: 1),
      .paragraphStyle: {
        var style = NSMutableParagraphStyle()
        style.alignment = .center
        return style
      }()
    ]
  }

  public var infoLabel = InfoLabel()
  public struct InfoLabel {
    public var enabled = true
    public var textColor = UIColor.white
    public var ellipsisText = NSLocalizedString("Show more", comment: "")
    public var ellipsisColor = UIColor(red: 137/255, green: 154/255, blue: 185/255, alpha: 1)

    public var textAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 12),
      .foregroundColor: UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
    ]
  }

  public var zoom = Zoom()
  public struct Zoom {
    public var minimumScale: CGFloat = 1.0
    public var maximumScale: CGFloat = 3.0
  }
}
