////
////  CardPaymentView.swift
////  GetStars
////
////  Created by Alejandro Miranda on 30/09/2020.
////  Copyright © 2020 Marquelo S.L. All rights reserved.
////
//
//import SwiftUI
//
//struct CardPaymentView: View {
//    @EnvironmentObject var session: SessionStore
//
//    @State var nombre: String = ""
//    @State var fechaCaducidad: String = ""
//    @State var numero: Int = 0
//
//    @State var cardTextField: STPPaymentCardTextField = {
//        let cardTextField = STPPaymentCardTextField()
//        return cardTextField
//    }()
//
//    @State var total: Double = 0.0
//
//    private func readCart() {
//        self.session.cart = session.getCart()
//        var dis: Double = 0.0
//        if self.session.cart.count >= 2 {
//            dis = 0.1 * Double(self.session.cart.count-1)
//            print("El descuento es \(dis.dollarString)€")
//        }
//        self.total = 0.0
//        for item in self.session.cart {
//            self.total += item.price - dis
//        }
//    }
//
//    var body: some View {
//        Group {
//            Text("Introduzca sus datos de pago")
//                .font(.system(size: 32, weight: .bold))
//                .padding()
//
//            Text("Total a pagar: \(self.total.dollarString)")
//                .padding()
//
//            Spacer()
//
//            StripeViewController()
//
//        }.onAppear(perform: {
//            self.readCart()
//        })
//    }
//}
//
//final class StripeViewController: UIViewController, STPAuthenticationContext {
//
//
//
//    @Environment(\.colorScheme) var colorScheme
//
//    var paymentIntentClientSecret: String?
//
//    lazy var cardTextField: STPPaymentCardTextField = {
//      let cardTextField = STPPaymentCardTextField()
//      return cardTextField
//    }()
//
//    lazy var payButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.layer.cornerRadius = 5
//        button.backgroundColor = UIColor.init(named: "navyBlue")
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
//        button.setTitle("Pay now", for: .normal)
//        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Stripe.setDefaultPublishableKey("pk_test_51HWnFdIx9ogp6GGIFQIBxC4rmz0cKgCglWtLlubFX6ObO3P18sflrB7210gKzpIn7gbHY2DTemJgEgyapEKS6A1b00sohezTmZ")
//
//        view.backgroundColor = UIColor.init(named: "blanco-splash")
//        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//        stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
//        view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
//        stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
//        ])
//        startCheckout()
//    }
//
//    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
//      DispatchQueue.main.async {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//        self.present(alert, animated: true, completion: nil)
//      }
//    }
//
//    func startCheckout() {
//      // Create a PaymentIntent as soon as the view loads
//      let url = URL(string: "" + "create-payment-intent")!
//      let json: [String: Any] = [
//        "items": [
//            ["id": "xl-shirt",
//             "price": 99.99],
//            ["id": "foto",
//             "price": 12.22]
//        ]
//      ]
//      var request = URLRequest(url: url)
//      request.httpMethod = "POST"
//      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//      request.httpBody = try? JSONSerialization.data(withJSONObject: json)
//      let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
//        guard let response = response as? HTTPURLResponse,
//          response.statusCode == 200,
//          let data = data,
//          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//          let clientSecret = json["clientSecret"] as? String else {
//              let message = error?.localizedDescription ?? "Failed to decode response from server."
//              self?.displayAlert(title: "Error loading page", message: message)
//              return
//        }
//        print("Created PaymentIntent")
//        self?.paymentIntentClientSecret = clientSecret
//      })
//      task.resume()
//    }
//
//    @objc
//    func pay() {
//      guard let paymentIntentClientSecret = paymentIntentClientSecret else {
//          return;
//      }
//      // Collect card details
//      let cardParams = cardTextField.cardParams
//      let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
//      let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
//      paymentIntentParams.paymentMethodParams = paymentMethodParams
//
//      // Submit the payment
//      let paymentHandler = STPPaymentHandler.shared()
//      paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
//        switch (status) {
//        case .failed:
//            self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
//            break
//        case .canceled:
//            self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
//            break
//        case .succeeded:
//            self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
//            break
//        @unknown default:
//            fatalError()
//            break
//        }
//      }
//    }
//
//}
//
//extension StripeViewController : UIViewControllerRepresentable {
//    public typealias UIViewControllerType = StripeViewController
//
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//    public func makeUIViewController(context: UIViewControllerRepresentableContext<StripeViewController>) -> StripeViewController {
//        return StripeViewController()
//    }
//
//    public func updateUIViewController(_ uiViewController: StripeViewController, context: UIViewControllerRepresentableContext<StripeViewController>) {
//
//    }
//}
//
//#if DEBUG
//struct CardPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardPaymentView()
//    }
//}
//#endif
//
