#!/usr/bin/env python
# -*- encoding: utf8 -*-

import matplotlib.pyplot as plt
import matplotlib.dates as mpldat

import numpy as np

import os, sys, getopt

verbose=0

def usage():
    """
    Show a message with the arguments and options of the script
    """

    print("Use: %s [OPTION] file" % sys.argv[0])
    print("""
      -h, --help          show this help
      -v, --verbose       be verbose
      -b, --begin         first point to graph (it can be negative)
      -e, --end           last point to graph (it can be negative)
      -t, --title         graph title
      -x, --xtitle        x axis title 
      -y, --ytitle        y axis title
      -L  --legend        Valores de la leyenda
      -l, --lines         draw horizontal and vertical lines
      -s, --scale         defines the scale factor
      -f, --file          defines the name of the file to save the plot

    """)
    return

def main():
    """
    Main program
    TODO
    """
    nameCurrentDir=os.getcwd().split('/')[-1]

    global verbose

    try: 
        # "hf:vdF:"["verbose","file=","download","help", "bandwidthFile="]
        """
        opts, args = getopt.gnu_getopt(sys.argv[1:], "hvs:tH:G:F:o:f:b:l:u:", ["verbose","help","sleep=","test",
        "hashtag=","back-hashtag=","folderfile=","output=", "file=", "begints=","lines=","user="])"""
        opts, args = getopt.gnu_getopt(sys.argv[1:], "hvb:e:t:x:,y:L:ls:f:",
                                       ["verbose","help", "begin=","end=","title=","xtitle=","ytitle=", "legend=","lines",
                                       "scale=", "file="])
        
    except getopt.GetoptError:
        # print help information and exit:
        usage()
        sys.exit(2)

    verbose=0
    begin=0
    end=-1
    TITLE=""
    XTITLE=""
    YTITLE=""
    LEGEND=[]  # fixme
    drawYLines=False
    scale=1
    savefile=None
    
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit()

        if o in ("-v", "--verbose"):
            verbose+=1

        if o in ("-b", "--begin"):
            begin=int(a)

        if o in ("-e", "--end"):
            end=int(a)

        if o in ("-t", "--title"):
            TITLE=a

        if o in ("-x", "--xtitle"):
            XTITLE=a

        if o in ("-y", "--ytitle"):
            YTITLE=a

        if o in ("-L", "--legend"):
            LEGEND=a.split()

        if o in ("-l", "--lines"):
            drawYLines=True

        if o in ("-s", "--scale"):
            scale=int(a)

        if o in ("-f", "--file"):
            savefile=a

    if len(args)>1:
        print("Only one file is allowed")
        usage()
        sys.exit(2)
    elif len(args)==1:
        inputfile=args[0]
    else:
        print("There is no file to plot")
        usage()
        sys.exit(2)

    data = np.loadtxt(inputfile)
    
    x = np.arange(len(data))
    dates=mpldat.epoch2num(data[begin:end,0])
    
    from matplotlib.dates import DateFormatter
    fig, ax1 = plt.subplots()
    
    ax2 = ax1.twinx()
    
    ax1.plot_date(dates, data[begin:end,1],'-')
    ax1.plot_date(dates, data[begin:end,2],'-')
    
    ax1.set_title(TITLE)    
    ax1.set_xlabel(XTITLE)
    ax1.set_ylabel(YTITLE)


    if drawYLines:
        plt.grid(True)
    
    #FIXME ponerla fuera
    ax1.legend(LEGEND, loc='center left')
 
    fig.autofmt_xdate()
    myFmt = DateFormatter("%Y-%m-%d %H:%M")
    ax1.xaxis.set_major_formatter(myFmt)

    if savefile!=None:
        fig.savefig(savefile)

    plt.show()


if __name__ == '__main__':
    main()