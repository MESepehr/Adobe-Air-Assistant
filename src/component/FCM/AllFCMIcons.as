package component.FCM
//component.FCM.AllFCMIcons
{
    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.display.BitmapData;

    public class AllFCMIcons extends MovieClip
    {
        private var W:Number,H:Number ;

        private var directories:Array = [] ;

        private var icons:Vector.<SingleIconFCM> ;

        private var iconsContainer:Sprite ;

        public function AllFCMIcons()
        {
            super();
            W = super.width;
            H = super.height ;
            this.removeChildren();

            iconsContainer = new Sprite();
            this.addChild(iconsContainer);
            new ScrollMT(iconsContainer,new Rectangle(0,0,W,H),null,false,true,false,false,false,0,false,true);
        }

        public function setUp(directoryNames:Array):void
        {
            iconsContainer.removeChildren();
            iconsContainer.graphics.clear();
            directories = directoryNames.concat() ;
            icons = new Vector.<SingleIconFCM>();
            const margin:Number = 0 ;
            var XN:Number = margin ;
            for(var i:int = 0 ; i<directories.length ; i++)
            {
                var icon:SingleIconFCM = new SingleIconFCM(directories[i]);
                icon.x = XN ;
                icon.y = (H-icon.height)/2;
                XN += margin + icon.width ;
                icons.push(icon);
                iconsContainer.addChild(icon);
            }
            iconsContainer.graphics.beginFill(0,0);
            iconsContainer.graphics.drawRect(0,0,iconsContainer.width,H);
        }

        public function getImage(fileName:String):BitmapData
        {
            for(var i:int = 0 ; i<icons.length ; i++)
            {
                trace(icons[i].fileName+' vs '+fileName);
                if(icons[i].fileName == fileName)
                {
                    return icons[i].getBitmapData();
                }
            }
            return null ;
        }

        public function setDefaultImage(newIcon:BitmapData)
        {
            for(var i:int = 0 ; i<icons.length ; i++)
            {
                icons[i].setIcon(newIcon);
            }
        }

        override public function get width():Number
        {
            return W ;
        }

        override public function get height():Number
        {
            return H ;
        }
    }
}