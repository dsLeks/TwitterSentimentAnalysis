import UIKit
import Charts

class UserResultsVC: UIViewController, ChartViewDelegate {

    var results: [TweetSentiment]? = nil
    var userName: String? = nil
    
    @IBOutlet weak var pieChartView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var pieChart: PieChartView = PieChartView()
    
    @IBAction func showDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "UserDetailSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        let logo = UIImage(named: "logo3")
        let imageView = UIImageView(image: logo)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.titleView = imageView
        
        // Setup Pie Chart Delegates
        pieChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Setup the frame of the bar chart to be the correct size
        pieChart.frame = CGRect(x: 0, y: 0, width: pieChartView.frame.size.width, height: pieChartView.frame.size.height - pieChartView.frame.size.height / 4)
        
        pieChart.center = CGPoint(x: pieChartView.center.x, y: pieChartView.center.y - pieChartView.center.y / 4)
        pieChartView.addSubview(pieChart)
        
        buildPieChart()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailResultVC = segue.destination as? DetailResultsVC else {
            print("Segue from OtherResultsVC not going to DetailResultsVC")
            return
        }
        
        
        detailResultVC.results = self.results
        detailResultVC.userName = self.userName
        
    }
    
    

    
    func buildPieChart() {
        // Create the positive and negative pie chart data entries
        
        var numPositiveTweets: Double = 0
        var numNegativeTweets: Double = 0
        var numNeutralTweets: Double = 0
        var numNotAnalyzedTweets: Double = 0
        
        
        let positiveEntry = PieChartDataEntry(value: 0)
        let negativeEntry = PieChartDataEntry(value: 0)
        let neutralEntry = PieChartDataEntry(value: 0)
        let notAnalyzedEntry = PieChartDataEntry(value: 0)
        
        positiveEntry.label = "Positive"
        negativeEntry.label = "Negative"
        neutralEntry.label = "Neutral"
        notAnalyzedEntry.label = "Not Analyzed"
        
        

        
        
        if let strongResults = results {
        
            for tweetSentiment in strongResults {
                
                var analysis = tweetSentiment.analysis
                
                guard let strongAnalysis = tweetSentiment.analysis else {
                    numNotAnalyzedTweets += 1
                    continue
                }
                
                
                if(strongAnalysis.documentSentiment.score > 0.1) {
                    numPositiveTweets += 1
                } else if(strongAnalysis.documentSentiment.score < -0.1) {
                    numNegativeTweets += 1
                } else {
                    numNeutralTweets += 1
                }
                
            }
            
            let numTweets = Double(strongResults.count)
            
            positiveEntry.value = numPositiveTweets / numTweets
            negativeEntry.value = numNegativeTweets / numTweets
            neutralEntry.value = numNeutralTweets / numTweets
            notAnalyzedEntry.value = numNotAnalyzedTweets / numTweets
            
        }
        
        
        let max = max(numPositiveTweets, numNegativeTweets, numNeutralTweets, numNotAnalyzedTweets)
        
        var summary: SentimentSummary = .NOTAPPLICABLE
        
        
        if max == numPositiveTweets {
            // User has been mostly positive
            summary = .POSITIVE
        } else if max == numNegativeTweets {
            // User has been mostly negative
            summary = .NEGATIVE
        } else if max == numNeutralTweets {
            // User has been mostly neutral
            summary = .NEUTRAL
        }
        
        
        
        let dataSet = PieChartDataSet(entries: [
        
            positiveEntry,
            
            negativeEntry,
            
            neutralEntry,
            
            notAnalyzedEntry
        
        ])
        dataSet.label = "Sentiment Analysis for @\(userName ?? "user")"
        dataSet.colors = [
            .systemGreen,
            .systemRed,
            .systemOrange,
            .systemGray
        ]
        
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
        
        
        handleSummary(summary)
        
    }
    
    func handleSummary(_ summary: SentimentSummary) {
        switch(summary) {
        case .NEUTRAL:
            summaryLabel.text = "@\(userName ?? "User") has been relatively neutral in their recent tweets."
            break;
        case .NEGATIVE:
            summaryLabel.text = "@\(userName ?? "User") has been NEGATIVE in their recent tweets."
            break;
        case .POSITIVE:
            summaryLabel.text = "@\(userName ?? "User") has been POSITIVE in their recent tweets."
            break;
        case .NOTAPPLICABLE:
            summaryLabel.text = "Could not analyze most recent tweets of @\(userName ?? "User")"
            break;
        }
    }
    
}
