import UIKit
import ARKit
import AVFoundation
import SpriteKit

class ARViewController: UIViewController {
    private var arSceneView: ARSCNView!
    private var videoNode: SKVideoNode?
    private var videoPlayer: AVPlayer?
    private var currentTarget: ARTarget?
    
    // MethodChannel callback
    var onTargetDetected: ((String) -> Void)?
    var onTargetLost: (() -> Void)?
    var onError: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARScene()
        setupUI()

        // Configurar target automaticamente
        let target = ARTarget(
            id: "orelhudo",
            imagePath: "orelhudo.png",
            videoPath: "orelhudo_1.mov",
            width: 9.0,
            height: 9.0
        )
        setupTarget(target)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseARSession()
    }

    private func setupARScene() {
        arSceneView = ARSCNView(frame: view.bounds)
        arSceneView.delegate = self
        view.addSubview(arSceneView)
    }

    private func setupUI() {
        // Back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Voltar", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.layer.cornerRadius = 10
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func startARSession() {
        guard ARImageTrackingConfiguration.isSupported else {
            onError?("ARKit não é suportado neste dispositivo")
            return
        }

        let configuration = ARImageTrackingConfiguration()
        
        // Load reference images
        loadReferenceImages { [weak self] referenceImages in
            configuration.trackingImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1
            self?.arSceneView.session.run(configuration)
        }
    }

    private func pauseARSession() {
        arSceneView.session.pause()
    }

    private func loadReferenceImages(completion: @escaping (Set<ARReferenceImage>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var referenceImages: Set<ARReferenceImage> = Set()

            // Load orelhudo image
            print("🔍 Tentando carregar imagem: orelhudo")
            if let orelhudoImage = UIImage(named: "orelhudo"),
               let cgImage = orelhudoImage.cgImage {
                print("✅ Imagem orelhudo carregada com sucesso!")
                let referenceImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2)
                referenceImage.name = "orelhudo"
                referenceImages.insert(referenceImage)
                print("✅ ARReferenceImage criada: \(referenceImage.name ?? "sem nome")")
            } else {
                print("❌ Erro ao carregar imagem orelhudo")
            }

            DispatchQueue.main.async {
                print("🔍 Enviando \(referenceImages.count) imagens de referência para ARKit")
                completion(referenceImages)
            }
        }
    }

    func setupTarget(_ target: ARTarget) {
        currentTarget = target
        print("✅ Target configurado: \(target.id)")
    }
    
    @objc private func playerDidFinishPlaying() {
        print("🔄 Vídeo terminou - reiniciando...")
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
    }
}

// MARK: - ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        print("🎯 IMAGEM DETECTADA! Nome: \(imageAnchor.referenceImage.name ?? "sem nome")")
        print("🎯 Status de tracking: \(imageAnchor.isTracked ? "TRACKING" : "NOT TRACKING")")

        // Load video
        print("🔍 Procurando vídeo: orelhudo_1.mov")
        guard let videoURL = Bundle.main.url(forResource: "orelhudo_1", withExtension: "mov") else {
            print("❌ Vídeo não encontrado no bundle!")
            onError?("Vídeo não encontrado")
            return
        }
        
        print("✅ Vídeo encontrado: \(videoURL)")
        
        // Create AVPlayer and SKVideoNode exactly like the demo
        let player = AVPlayer(url: videoURL)
        videoPlayer = player
        videoNode = SKVideoNode(avPlayer: player)
        
        // Get image dimensions
        let imageSize = imageAnchor.referenceImage.physicalSize
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        // Create video scene with aspect ratio matching the image
        let aspectRatio = imageWidth / imageHeight
        let videoWidth: CGFloat = 1280
        let videoHeight = videoWidth / CGFloat(aspectRatio)
        
        let videoScene = SKScene(size: CGSize(width: videoWidth, height: videoHeight))
        videoScene.backgroundColor = UIColor.clear
        
        // Position and size video node to fill the entire scene
        videoNode?.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode?.size = videoScene.size
        videoNode?.yScale = -1.0  // Flip vertically to fix upside-down issue
        videoScene.addChild(videoNode!)
        
        // Create plane with exact image dimensions
        let plane = SCNPlane(width: CGFloat(imageWidth), height: CGFloat(imageHeight))
        
        // Set video directly - no more test
        plane.firstMaterial?.diffuse.contents = videoScene
        plane.firstMaterial?.isDoubleSided = true
        
        print("🎬 Vídeo configurado diretamente!")
        print("📐 Vídeo ajustado para cobrir toda a imagem: \(videoWidth) x \(videoHeight)")
        
        // Create plane node
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2  // Rotate to be horizontal
        
        // Add to scene
        node.addChildNode(planeNode)
        
        // Start playback
        videoNode?.play()
        player.play()
        
        // Set up loop notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        print("✅ VideoNode criado e adicionado à cena!")
        print("▶️ Vídeo iniciado!")
        print("📐 Dimensões da imagem: \(imageWidth) x \(imageHeight)")
        print("📐 Aspect ratio: \(aspectRatio)")
        print("🎬 Dimensões da cena: \(videoWidth) x \(videoHeight)")
        print("🎯 Posição do vídeo: \(videoNode?.position ?? CGPoint.zero)")
        
        onTargetDetected?(currentTarget?.id ?? "orelhudo")
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        if imageAnchor.isTracked {
            // Only log occasionally to reduce spam
            if Int.random(in: 1...30) == 1 {
                print("🎯 IMAGEM SENDO RASTREADA: \(imageAnchor.referenceImage.name ?? "sem nome")")
            }
        } else {
            // Only log occasionally to reduce spam
            if Int.random(in: 1...30) == 1 {
                print("🎯 IMAGEM PERDIDA: \(imageAnchor.referenceImage.name ?? "sem nome")")
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        DispatchQueue.main.async {
            print("🎯 IMAGEM REMOVIDA: \(imageAnchor.referenceImage.name ?? "sem nome")")
            
            // Remove notification observer
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            self.videoPlayer?.pause()
            self.videoPlayer = nil
            self.videoNode?.pause()
            self.videoNode = nil
            self.onTargetLost?()
        }
    }
}