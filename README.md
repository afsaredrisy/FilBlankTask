## FilBlankGame
Fill Blank is a fun game, you will be providing a paragraph that will contains some blank. This paragraph will be from random wikipedia page you have to fill blanks one correct fill will give you one point.

## Demo
  ![Alt Text](https://nsobject.s3.us-east-2.amazonaws.com/ezgif.com-optimize.gif)


## Usage

  - Clone this repository and open ```FilBlankTask.xcworkspace``` . 
  - No need to install any Pod file.
  - Change email id in ```WikipediaNetworking``` file
  ```public static var appAuthorEmailForAPI = "client@domain.com"```
WikipediaKit will use this email address and your app’s bundle info to generate and send a User-Agent header. This will identify your app to Wikipedia’s servers with every API request, as required by the API guidelines.
The ```User-Agent``` header is printed to your Xcode console when you make the first API request. It’ll look something like this:


## How to play
   - Play game by tapping the Splash screen ```Play``` Button.
   - While playing you will be showing  ```____```  by tapping on blank a sheet will open that will contain the shuffled words you can select one of them. Filler word will be display in red color & in different font. 
   - When you will submit your solution you will get your score. System will remeber your Maximum score
   - You can also tap on ```see result``` button to see where you made mistake in red color and where you filled correct word in green color. 
 
## How it works 
This project uses [WikipediaKit](https://github.com/Raureif/WikipediaKit) to fetch random wiki article. This library uses MediaWiki API.
# Algorithm 
1. Fetch the random article from wikipedia by using [WikipediaKit](https://github.com/Raureif/WikipediaKit)
2.  Break the data of result [revision](https://www.mediawiki.org/wiki/API:Revisions) into sentances using [NSLinguisticTagger](https://docs.microsoft.com/en-us/dotnet/api/foundation.nslinguistictagger?view=xamarin-ios-sdk-12) class. This class provides the support for NLP in Swift. 
3. Check the number of sentances created in step 2, if the number of sentances less than 10 then Go to step 1.
4. Get a random integer in range ```0..numberOfSentances``` let ```X```, in Sentance at index ```x```  a single word has to removed in next step.
5. Check whether a set of indexes of already removed words from sentances contains index ```X``` or not if yes repeat step 4 otherwise goto step 5. 
6. Tokenize the ```sentance[X]``` using [NSLinguisticTagger](https://docs.microsoft.com/en-us/dotnet/api/foundation.nslinguistictagger?view=xamarin-ios-sdk-12) This will help to identify the parts of speech of words as well, assume this list of token (words) as words.
7. Get a random integer in range ```0..words.count```. let it ```y```  
8. Check whethen a set of already removed words contains ```words[y]``` or not if not then identify the parts of speech of ```words[y]``` if parts of speech is in set ```[determiner, adjective, noun, preposition, verb, preposition]``` then insert this word in already removed set. Removing words of these parts of speech increases the difficulty of game.
9. Save the ```NSRAnge``` of the word and word in full article text i.e data of [revision](https://www.mediawiki.org/wiki/API:Revisions) in a object of Dictionary. and replace actual word with ______ (blanks) in article text.
10. Repeat step 4 to 10 untill size of set of already removed sentances is less than 10.
8. Create [NSMutableAttributedString](https://developer.apple.com/documentation/foundation/nsmutableattributedstring) object from data of result [revision](https://www.mediawiki.org/wiki/API:Revisions).
9. Create custom attributes at for all ```NSRange``` saved in step 9. These attributes will be for handling onTapped event on ______.
10. Create [NSAttributedString](https://developer.apple.com/documentation/foundation/nsattributedstring) from object of [NSMutableAttributedString](https://developer.apple.com/documentation/foundation/nsmutableattributedstring) created in step 11 and render text on [UITextView](https://developer.apple.com/documentation/uikit/uitextview).
11. Add a ```UITapGestureRecognizer``` on [UITextView](https://developer.apple.com/documentation/uikit/uitextview) object. like this ```let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))``` Note: ViewController class should confirm the ```UIGestureRecognizerDelegate``` protocol. and declare method ```@objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer)```
12. When user will tap on blank ```myMethodToHandleTap``` will invoked. Here Identify the ```NSRange``` of tapped attribute, open Sheet with shuffled words of set of already removed words.
13. Once user select a words, replace selected word by ______ at ```NSRange``` in [NSAttributedString](https://developer.apple.com/documentation/foundation/nsattributedstring) .
14. Save selected word and actual word in a Dictionary ```[String: String]``` where key is selected word & value is actual word at attribute ```NSRange```.
15. Update ```NSRange``` of all attributes in [NSAttributedString](https://developer.apple.com/documentation/foundation/nsattributedstring).
16. When user submit the result update all attribute range and then chek whether user filled all blanks or not if filled all compare Dictionary key with value created in step 17.
17. Publish result and stop.

## Extention
Currently game does not provide any room to make mistake once you filled one ______ you will not be able to change it.
## Requirments 
Internet connection is required to run this app. for batter experience run app in actual iOS devices instead of simulator.


