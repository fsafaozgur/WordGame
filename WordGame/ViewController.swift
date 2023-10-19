//
//  ViewController.swift
//  WordGame
//
//  Created by Safa on 19.10.2023.
//


import UIKit

class ViewController: UIViewController {
    
    var cluesLabel : UILabel!
    var answerLabel : UILabel!
    var currentLabel : UILabel!
    var scoreLabel : UILabel!
    var submitButton : UIButton!
    var clearButton : UIButton!
    var letterButtons = [UIButton]()
    var currentAnswer : UITextField!
    var buttonsView : UIView!
    var pressedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet{
            scoreLabel.text = "Skor: \(score)"
        }
    }
    var level = 1
    var message : Message?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.font = UIFont.systemFont(ofSize: 30)
        scoreLabel.text = "Skor : 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: NSLayoutConstraint.Axis.vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.textAlignment = .left
        cluesLabel.font = UIFont.systemFont(ofSize: 25)
        cluesLabel.numberOfLines = 0    //ne kadar gerekliyse o kadar satir olsun
        cluesLabel.backgroundColor = .blue
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: NSLayoutConstraint.Axis.vertical)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.textAlignment = .left
        answerLabel.font = UIFont.systemFont(ofSize: 25)
        answerLabel.numberOfLines = 0    //ne kadar gerekliyse o kadar satir olsun
        answerLabel.backgroundColor = .yellow
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tuslara Basarak Tahmininizi Yapin"
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(currentAnswer)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Gonder", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        submitButton.addTarget(self, action: #selector(submitTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(submitButton)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Temizle", for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        clearButton.addTarget(self, action: #selector(clearTapped), for: UIControl.Event.touchUpInside)
        view.addSubview(clearButton)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .white
        view.addSubview(buttonsView)
    
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.7),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buttonsView.widthAnchor.constraint(equalToConstant: 600),
            buttonsView.heightAnchor.constraint(equalToConstant: 320)
            
        ])
        
        let buttonWidth = 120
        let buttonHeight = 80
        
        //Kelime parcaciklarini yazacagimiz buttonlari olusturuyoruz
        for row in 0...3 {
            for col in 0...4 {
                let button = UIButton(frame: CGRect(x: col * buttonWidth, y: row * buttonHeight, width: buttonWidth-5, height: buttonHeight-5))
                button.setTitle("FSO", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .blue
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.addTarget(self, action: #selector(letterTapped), for: UIControl.Event.touchUpInside)
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
            
        //Text dosyasindan aldigimiz veriler ile ekrani dolduruyoruz
        loadWords()
        
    }
    
    
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    
    //Text dosyasindan verileri cekerek ekrani doldurma
    @objc func loadWords () {
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        guard let path  = Bundle.main.url(forResource: "Level\(level)", withExtension: "txt") else {return}
        if let content = try? String(contentsOf: path) {
            //Cekilen satirlari bir diziye ayri ayri ekliyoruz
            var allLines = content.components(separatedBy: "\n")
            //Her defasinda ekrana ayri bir siralama ile ekrana basmak icin karistiriyoruz
            allLines.shuffle()
            
            //Satirlari index numarasi ile birlikte cekiyoruz
            for (index, line) in allLines.enumerated(){
                //Text dosyasindaki : sembol] yardimiyla kelimeler ile aciklamalari ayiriyoruz
                let parts = line.components(separatedBy: ":")
                //Kelimeyi aliyoruz
                let answer = parts[0]
                //Ipucunu aliyoruz
                let clue = parts[1]
                
                //Kelimedeki | isaretini temizleyerek kelimeyi tek parca elde ediyoruz
                let solution = answer.replacingOccurrences(of: "|", with: "")
                //Tek parca olan kelimenin harf sayisini elde ediyoruz
                solutionString += "\(solution.count) harf\n"
                //Kelimeyi tek parca olarak dizimize ekliyoruz
                solutions.append(solution)
                
                //Ipucumuzu diziye ekliyoruz
                clueString += "\(index+1). \(clue)\n"
                
                //Kelimenin parcalanmis halindeki her bir parcayi bir diziye ekliyoruz, daha sonra bu parcalarin her birini buttonlarin uzerine yazacagiz
                let bits = answer.components(separatedBy: "|")
                letterBits += bits
            }
        }
        
        //Tum ipuclarini ekrana basiyoruz
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        //Bu halde ilk olarak harf sayilari ekrana basiliyor, daha sonra cevaplar geldikce solutionString dizisindeki harf sayisi verilen cevabin yerine kullanici tarafindan dogru olarak girilen cevap gelecek ve tekrar ekrana basilacak
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Kelime parcalarini karistiriyoruz ki ekrana her defasinda farkli siralamada basilsin
        letterBits.shuffle()
        
        //Daha once olusturdugumuz buttonlarin Title bilgilerini, letterBits dizimiz icerisine ekledigimiz kelime parcalari ile dolduruyoruz
        if letterBits.count == letterButtons.count {
            for num in 0..<letterButtons.count {
                letterButtons[num].setTitle("\(letterBits[num])", for: UIControl.State.normal)
            }
            
        }
        
        
     
        
    }


    //Kelime parcalarini gosteren buttonlardan birine basilirsa bu fonksiyon tetiklenecek
    @objc func letterTapped(_ sender: UIButton) {
        
        if let tappedText = sender.titleLabel?.text {
            //Basilan button uzerindeki text verisini labelimize ekliyoruz, her yeni tiklamada label icinde bulunan yazilar silinmeden bunlara eklenmesini sagliyoruz
            currentAnswer.text = currentAnswer.text?.appending(tappedText)
            //Basilan tusu bir diziye ekliyoruz
            pressedButtons.append(sender)
            //Basilan tusu ekranda gorulmez hale getiriyoruz
            sender.isHidden = true
        }
        
    }

    
    //Kullanici tarafindan girilen kelimenin gonderilmesi
    @objc func submitTapped(_ sender: UIButton) {
        
        //Label dolu mu
        guard let submittedAnswer = currentAnswer.text else {return}
        
        //Girilen kelime bizim text dosyasindan cektigimiz kelimelerden biriyse o halde kacinci siradaki oldugunu belirliyoruz
        if let answerIndex = solutions.firstIndex(of: submittedAnswer) {
            
            //answerLabel uzerinde degisiklik yaptigimiz icin her defasinda oradaki verileri almamiz gerekiyor, haliyle satir sonu isareti ile ayirarak tum cevaplari satir satir cekiyoruz ve diziye atiyoruz
            var splittedAnswers = answerLabel.text?.components(separatedBy: "\n")
            //Kullanicinin girdigi kelimenin satiri hangisi ise o satira cevabi yukluyoruz
            splittedAnswers?[answerIndex] = submittedAnswer
            //Ayirdigimiz satirlari bu defa aralarina satir basi isareti koyarak birlestiriyoruz
            answerLabel.text = splittedAnswers?.joined(separator: "\n")
            
            //Submit islemi yapildigi icin artik currentAnswer labelini sifirliyoruz
            currentAnswer.text = ""
            //Skoru arttiriyoruz, degisken observer ile izlendigi icin bu degisiklik hemen scoreLabel a isleniyor
            score += 1
            //Basilan tuslari kaydettigimiz diziyi sifirliyoruz cunku bu diziyi clearButton a basilirsa daha once basilan tuslari tekrar ekrana getirmek icin tutuyorduk, submit islemi basarili olduysa artik clearButton a basarak geri getirecegimiz birsey kalmamis demektir
            pressedButtons.removeAll()
            
            
            //Kelimelerin hepsi dogru bilindiyse mod7 bize sifir donecektir
            if score % 7 == 0 {
                
                //Level atlatiyoruz
                level += 1
                
                //Projemizde 2 tane level(Level1.txt ve Level2.txt) oldugu icin eger 2. level basariyla gecilirse oyun bitiyor ve burada bunun kontrolu yapiliyor
                if level != 3 {
                    message = .LevelUp
                }else{
                    message = .Finished
                }
                
                let alertVC = UIAlertController(title: message?.messages[0], message: message?.messages[1], preferredStyle: UIAlertController.Style.alert)
                let button = UIAlertAction(title: message?.messages[2], style: UIAlertAction.Style.default, handler: prepareUI)
                alertVC.addAction(button)
                self.present(alertVC, animated: true)
            }
            
        }else {
            //Eger listede olmayan yanlis bir kelime girildiyse
            message = .InvalidWord
            
            let alertVC = UIAlertController(title: message?.messages[0], message: message?.messages[1], preferredStyle: UIAlertController.Style.alert)
            let button = UIAlertAction(title: message?.messages[2], style: UIAlertAction.Style.default, handler: clearLabel)
            alertVC.addAction(button)
            self.present(alertVC, animated: true)
            
        }
        
    }

    //clearButton tiklanirsa
    @objc func clearTapped(_ sender: UIButton) {
        
        for button in pressedButtons {
            button.isHidden = false
        }
        
        currentAnswer.text = ""
        pressedButtons.removeAll()
    }
    
    
    
    //Bolum sonlarinda yeni level e mi gecilecek yoksa oyun mu bitecek kontrolu ardindan sonuca gore ekrana veri getiren fonksiyon
    func prepareUI(action: UIAlertAction) {


        //Kullanicidan gelen submit lerin dogrulu[unu kontrol etmek icin tuttugumuz diziyi sifirliyoruz, bu diziyi yeni leveldeki dogru cevaplarla ya da oyun bittiyse 1. leveldeki dogru cevaplarla dolduracaz
        solutions.removeAll(keepingCapacity: true)
        
        //Oyun bittiyse
        if level == 3 {
            level = 1
            score = 0
        }
        //Guncel duruma gore ver yuklemesi yapiliyor(ekrana getiriliecek levele gore)
        loadWords()
    
        //Tum tuslar yeniden aktif hale getiriliyor
        for btn in letterButtons {
            btn.isHidden = false
        }
        
    }
    
    
    //Yanlis kelime girildiginde yapilacak islemler
    func clearLabel (action: UIAlertAction) {
        for button in pressedButtons {
            button.isHidden = false
        }
        
        currentAnswer.text = ""
        pressedButtons.removeAll()
        
    }
    
    
    //Bolum basariyla gecilince ya level atlaniyor ya oyun bitiyor, bu iki durumu ve bu durumlara ozel olarak ekrana basilacak mesajlari Enum bir degiskende tutuyoruz
    enum Message {
        
        case LevelUp
        case Finished
        case InvalidWord
        
        var messages : [String] {
            
            switch self {
            case .LevelUp:
                return ["Bravo", "Seviyeyi gectiniz", "Devam et"]
            case .Finished:
                return ["Tebrikler", "Kazandiniz", "Yeniden oyna"]
            case .InvalidWord:
                return ["Uzgunuz", "Yanlis cevap! Tekrar deneyiniz", "Yeniden dene"]
            }
        
        }
    }
        
}


