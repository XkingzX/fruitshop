import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnThemCss: UIButton!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var tbFruit: UITableView!
    @IBOutlet weak var txtThem: UITextField!

    var fruits: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbFruit.dataSource = self
        tbFruit.delegate = self
        
        loadFruits()
        
        tbFruit.reloadData()
        customButton()
    }

    func customButton() {
        btnThemCss.layer.cornerRadius = 20
        btnThemCss.layer.borderWidth = 2.0
        btnThemCss.layer.borderColor = UIColor.black.cgColor
        
        
        btnRefresh.layer.cornerRadius = 20
        btnRefresh.layer.borderWidth = 2.0
        btnRefresh.layer.borderColor = UIColor.black.cgColor
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath) as! FruitCell
        let fruit = fruits[indexPath.row]

        cell.lblName.text = fruit.0
        cell.imvHinhSanPham.image = UIImage(named: fruit.1)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fruits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveFruits()
        }
    }

    @IBAction func btnThem(_ sender: Any) {
        if let fruitName = txtThem.text, !fruitName.isEmpty {
            
            fruits.append((fruitName, "defaultImage.png"))
            tbFruit.reloadData()
            txtThem.text = ""
            saveFruits()
        } else {
            let alert = UIAlertController(title: "Lỗi", message: "Vui lòng nhập tên trái cây.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnRefresh(_ sender: Any) {
        fruits = [
            ("Tao", "apple.png"),
            ("Chuoi", "chuoi.png"),
            ("Cam", "orange.png"),
            ("Nho", "nho.png"),
            ("Dua Hau", "duahau.png")
        ]
        saveFruits()
        tbFruit.reloadData()
    }
    
    func saveFruits() {
        let fruitData = fruits.map { ["name": $0.0, "image": $0.1] }
        UserDefaults.standard.set(fruitData, forKey: "fruitsList")
    }

    
    func loadFruits() {
        if let savedFruits = UserDefaults.standard.array(forKey: "fruitsList") as? [[String: String]] {
            fruits = savedFruits.compactMap { dict in
                guard let name = dict["name"], let image = dict["image"] else { return nil }
                return (name, image)
            }
        } else {
            fruits = [
                ("Tao", "apple.png"),
                ("Chuoi", "chuoi.png"),
                ("Cam", "orange.png"),
                ("Nho", "nho.png"),
                ("Dua Hau", "duahau.png")
            ]
        }
    }
}
