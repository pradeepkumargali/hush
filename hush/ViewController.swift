//
//  ViewController.swift
//  hush
//
//  Created by Pradeep Gali on 08/11/14.
//  Copyright (c) 2014 Pradeep Gali. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {

    
    @IBOutlet var tableView: UITableView?
    
    var items:[NSManagedObject]=[]
    var player : AVAudioPlayer! = nil
    var session: AVAudioSession! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register Cell
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.separatorStyle=UITableViewCellSeparatorStyle.None
        
        
        var instanceOfCustomObject: NetworkUtility = NetworkUtility()
        

        //Background Audio Mode
        //instanceOfCustomObject.pluginInitialize()

        let path = NSBundle.mainBundle().pathForResource("silent", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = try? AVAudioPlayer(contentsOfURL: fileURL)

        player.prepareToPlay()

        player.delegate = self

        player.numberOfLoops = -1

        player.volume=0

        

        session=AVAudioSession.sharedInstance()

        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
        } catch _ {
        }

        do {
            try session.setActive(true)
        } catch _ {
        }

        

        

        

        

        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keepAwake:", name: UIApplicationDidEnterBackgroundNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopKeepingAwake:", name: UIApplicationWillEnterForegroundNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAudioSessionInterruption:", name: AVAudioSessionInterruptionNotification, object: nil)

        /*[listener addObserver:self

            selector:@selector(keepAwake)

        name:UIApplicationDidEnterBackgroundNotification

        object:nil];

        

        [listener addObserver:self

        selector:@selector(stopKeepingAwake)

        name:UIApplicationWillEnterForegroundNotification

        object:nil];

        

        [listener addObserver:self

        selector:@selector(handleAudioSessionInterruption:)

        name:AVAudioSessionInterruptionNotification

        object:nil];*/

        

        let r = Reachability.reachabilityForLocalWiFi()

        r.reachableOnWWAN = false

        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hushItUp:", name: kReachabilityChangedNotification, object: nil)

        

        

        r.startNotifier()

        

        print(instanceOfCustomObject.GetCurrentWifiHotSpotName())

        //s ?? b

        

        //1

        let appDelegate =

        UIApplication.sharedApplication().delegate as! AppDelegate

        

        let managedContext = appDelegate.managedObjectContext!

        

        //2

        let fetchRequest = NSFetchRequest(entityName:"SSIDS")

        

        //3

        var error: NSError?

        

        let fetchedResults =

        managedContext.executeFetchRequest(fetchRequest,

            error: &error) as [NSManagedObject]?

        

        if let results = fetchedResults {

            items = results

        } else {

            print("Could not fetch \(error), \(error!.userInfo)")

        }

        

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if var fromDB=self.checkSSID(s){

                var isSelected=fromDB.valueForKey("choice") as! Bool

                if isSelected {

                    instanceOfCustomObject.silentPhone()

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                }

                

            }

            else{

                self.saveSSID(s,choice: false)

            }

        }

        else

        {

            instanceOfCustomObject.unsilencePhone()

        }

        self.tableView?.reloadData()

        

      //  WifiName.text=s ?? ""

     

    }

    

    func keepAwake(sender:NSNotification!){

        print("App Entered Background")

        //sender.keepAwake()

        player.play()

        

        

    }

    func stopKeepingAwake(sender:NSNotification!){

        print("App Entered ForeGround")

        player.pause()

    }

    func handleAudioSessionInterruption(sender:NSNotification!){

        print("Audio Interruption")

        player.play()

    }

    

    override func viewWillAppear(animated: Bool) {

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        print(instanceOfCustomObject.GetCurrentWifiHotSpotName())

        //s ?? b

        

        //1

        let appDelegate =

        UIApplication.sharedApplication().delegate as! AppDelegate

        

        let managedContext = appDelegate.managedObjectContext!

        

        //2

        let fetchRequest = NSFetchRequest(entityName:"SSIDS")

        

        //3

        var error: NSError?

        

        let fetchedResults =

        managedContext.executeFetchRequest(fetchRequest,

            error: &error) as [NSManagedObject]?

        

        if let results = fetchedResults {

            items = results

        } else {

            print("Could not fetch \(error), \(error!.userInfo)")

        }

        

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if var fromDB=self.checkSSID(s){

                var isSelected=fromDB.valueForKey("choice") as! Bool

                if isSelected {

                    instanceOfCustomObject.silentPhone()

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                }

                

            }

            else{

                self.saveSSID(s,choice: false)

            }

        }

        else

        {

            instanceOfCustomObject.unsilencePhone()

        }

        self.tableView?.reloadData()

    }



    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.

    }

    

    func hushItUp (sender:NSNotification) {

        print("Hushing it Up");

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        print(instanceOfCustomObject.GetCurrentWifiHotSpotName())

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if var fromDB=checkSSID(s){

                println(fromDB.valueForKey("choice") as! Bool)

                var isSelected = fromDB.valueForKey("choice") as! Bool

                if isSelected{

                    instanceOfCustomObject.silentPhone()

                    //completionHandler(UIBackgroundFetchResult.NoData)

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                    //completionHandler(UIBackgroundFetchResult.NoData)

                }

                

            }

            else{

                saveSSID(s,choice: false)

                //completionHandler(UIBackgroundFetchResult.NewData)

                

            }

        }

        else

        {

            instanceOfCustomObject.unsilencePhone()

            //completionHandler(UIBackgroundFetchResult.NoData)

            

        }

    }

    

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print(items.count)

        return items.count

    }

    

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell:UITableViewCell = self.tableView?.dequeueReusableCellWithIdentifier("cell") as UITableViewCell

        let item = items[indexPath.row]

        var switchDemo : UISwitch? = cell.viewWithTag(100) as! UISwitch?

        if switchDemo != nil {

        

        switchDemo?.on = item.valueForKey("choice") as! Bool

        switchDemo?.setOn(item.valueForKey("choice") as! Bool, animated: true);

        

        }

        else

        {

            //var switchDemo=UISwitch(frame:CGRectMake(0, 50, 0, 0))

            switchDemo=UISwitch()

            var switchSize:CGSize? = switchDemo?.sizeThatFits(CGSize.zero)

            var switchWidth = switchSize?.width

            var switchHeight = switchSize?.height

            switchDemo?.frame=CGRectMake(cell.contentView.bounds.size.width - switchWidth! - 5.0, (cell.contentView.bounds.size.height - switchHeight!)/2.0, switchWidth!, switchHeight!)

            switchDemo?.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin

            

            switchDemo?.on = item.valueForKey("choice") as! Bool

            switchDemo?.setOn(item.valueForKey("choice") as! Bool, animated: true);

            switchDemo?.addTarget(self, action: "switchValueDidChange:", forControlEvents: .ValueChanged)

            switchDemo?.tag = 100

            cell.addSubview(switchDemo!)

            

        }

        

        cell.selectionStyle = UITableViewCellSelectionStyle.None

        var label : UILabel? = cell.viewWithTag(200) as! UILabel?

        

        if label != nil {

          label?.text = item.valueForKey("name") as! String?

            

        }

        else {

        label = UILabel()

        var labelFrame = CGRectInset(cell.contentView.bounds, 10, 8)

        labelFrame.size.width = cell.contentView.bounds.size.width*2/3

        label?.frame = labelFrame

        label?.font = UIFont.boldSystemFontOfSize(17)

        label?.tag = 200

        label?.text = item.valueForKey("name") as! String?

        

        cell.addSubview(label!)

        }

        

        return cell

    }

    

    func switchValueDidChange(sender:UISwitch!){

        var cell: UITableViewCell = sender.superview as! UITableViewCell

        

        var label: UILabel = cell.viewWithTag(200) as! UILabel

        

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if s == label.text{

                //var isSelected=fromDB.valueForKey("choice") as Bool

                if sender.on==true {

                    instanceOfCustomObject.silentPhone()

                    self.updateSSID(s,choice: true)

                    //self.tableView?.reloadData()

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                    self.updateSSID(s,choice: false)

                    //self.tableView?.reloadData()

                }

                

            }

            else

            {

                if sender.on==true {

                    self.updateSSID(label.text!,choice: true)

                }

                else{

                    self.updateSSID(label.text!,choice: false)

                }

                

            }

        }

        else

        {

            if sender.on==true {

           self.updateSSID(label.text!,choice: true)

            }

            else{

                self.updateSSID(label.text!,choice: false)

            }

        }

    }

    

    func saveSSID(name: String, choice: Bool) {

        //1

        let appDelegate =

        UIApplication.sharedApplication().delegate as! AppDelegate

        

        let managedContext = appDelegate.managedObjectContext!

        

        //2

        let entity =  NSEntityDescription.entityForName("SSIDS",

            inManagedObjectContext:

            managedContext)

        

        let person = NSManagedObject(entity: entity!,

            insertIntoManagedObjectContext:managedContext)

        

        //3

        person.setValue(name, forKey: "name")

        person.setValue(choice, forKey: "choice")

        

        //4

        var error: NSError?

        if !managedContext.save(&error) {

            print("Could not save \(error), \(error?.userInfo)")

        }  

        //5

        items.append(person)

        self.tableView?.reloadData()

    }

    

    func checkSSID(ssid : String) -> NSManagedObject!{

        //1

        let appDelegate =

        UIApplication.sharedApplication().delegate as! AppDelegate

        

        let managedContext = appDelegate.managedObjectContext!

        

        //2

        let entity =  NSEntityDescription.entityForName("SSIDS",

            inManagedObjectContext:

            managedContext)

        

        let fs : NSFetchRequest = NSFetchRequest(entityName: "SSIDS")



        

        //3

        //var ssid :String! = "TP-LINK_POCKET_3020_A48506"

        let predicate: NSPredicate = NSPredicate(format: "name = %@", ssid)

        fs.predicate=predicate

        

        var error: NSError? = nil

        if let fr = managedContext.executeFetchRequest(fs, error: &error) {

          //  println("Could not save \(error), \(error?.userInfo)")

            if fr.count > 0 {

            return fr[0] as NSManagedObject

            }

            else

            {

                return nil

            }

            //fr.

        }

        else{

            return nil

        }

        

        

        

        

        

        }

    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print("You selected cell #\(indexPath.row)!")

        var cell: UITableViewCell=tableView.cellForRowAtIndexPath(indexPath)!

        var switcher: UISwitch = cell.viewWithTag(100) as! UISwitch

        switcher.setOn(!switcher.on, animated: true)

        

        var label: UILabel = cell.viewWithTag(200) as! UILabel

        

        var instanceOfCustomObject: NetworkUtility = NetworkUtility()

        if var s = instanceOfCustomObject.GetCurrentWifiHotSpotName(){

            print(s)

            if s == label.text{

                //var isSelected=fromDB.valueForKey("choice") as Bool

                if switcher.on==true {

                    instanceOfCustomObject.silentPhone()

                    self.updateSSID(s,choice: true)

                    //self.tableView?.reloadData()

                }

                else

                {

                    instanceOfCustomObject.unsilencePhone()

                    self.updateSSID(s,choice: false)

                    //self.tableView?.reloadData()

                }

                

            }

            else

            {

                if switcher.on==true {

                    self.updateSSID(label.text!,choice: true)

                }

                else{

                    self.updateSSID(label.text!,choice: false)

                }

            }

        }

        else

        {

            if switcher.on==true {

                self.updateSSID(label.text!,choice: true)

            }

            else{

                self.updateSSID(label.text!,choice: false)

            }

        }

        

    }

    

    func updateSSID(name :String, choice: Bool){

        //1

        let appDelegate =

        UIApplication.sharedApplication().delegate as! AppDelegate

        

        let managedContext = appDelegate.managedObjectContext!

        

        //2

        let entity =  NSEntityDescription.entityForName("SSIDS",

            inManagedObjectContext:

            managedContext)

        

        let fs : NSFetchRequest = NSFetchRequest(entityName: "SSIDS")

        

        

        //3

        //var ssid :String! = "TP-LINK_POCKET_3020_A48506"

        let predicate: NSPredicate = NSPredicate(format: "name = %@", name)
        fs.predicate=predicate
        
        var error: NSError? = nil
        if let fr = managedContext.executeFetchRequest(fs, error: &error) {
            //  println("Could not save \(error), \(error?.userInfo)")
            if fr.count > 0 {
                println(fr)
                fr[0].setValue(name, forKey: "name")
                fr[0].setValue(choice, forKey: "choice")
                managedContext.save(&error)
            }
            else
            {
               
            }
            //fr.
        }
        else{
           
        }
    
    }
    
    func updateTableView(){
        self.tableView?.reloadData()
    }



}

