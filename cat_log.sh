#!/system/bin/sh

 #/proc/sys/kernel/panic发生“内核严重错误（kernel panic）”，则内核在重新引导之前等待的时间（以秒为单位）。缺省0为禁止重新引导 by zxx
 echo 1 > /proc/sys/kernel/panic
 



 LOG_DIR="/mnt/sdcard/.LOGSAVE"
 LAST_LOG_DIR="/mnt/sdcard/.LOGSAVE/last"
 SAVE_LOG_COUNT=5   # 保存上5次的log，值最小为1;最大为5,则last.1为最近的log；last.5为最久的log；  每一次触发都会搬移数据，
 

#创建保存目录
 if [ ! -d "$LOG_DIR" ];then
    mkdir $LOG_DIR
 fi
 
#删除last.5目录
 if [  -d "$LAST_LOG_DIR.$SAVE_LOG_COUNT" ];then
    rm -r "$LAST_LOG_DIR.$SAVE_LOG_COUNT"
 fi
 
 
#4有东西搬到5，3有东西搬到4...   所以last.1保持最新的   每触发一次，last.1更新一次  也就是数据会搬移一次
 i=$((SAVE_LOG_COUNT -1))
 while [ $i -ge 1 ]
 do 
          if [  -d "$LAST_LOG_DIR.$i" ];then

                 if [ "`ls -a $LAST_LOG_DIR.$i`" = "" ]; then
                         echo "$LAST_LOG_DIR.$i is indeed empty"
                 else
                         echo "$LAST_LOG_DIR.$i is not empty"
                         j=$(($i+1)) 
			 #这里只是重命名
                         mv  "$LAST_LOG_DIR.$i"  "$LAST_LOG_DIR.$j"
                 fi
 
                 
                 
          fi
          i=$(($i-1))
          
 done
 
 #创建last.1目录 因为每次移动后，也就是重新命名后，原目录就没有了
 mkdir $LAST_LOG_DIR."1"
 
 #开机后移动上次关机的log到last.1
 mv $LOG_DIR/*.log $LAST_LOG_DIR."1"
 mv $LOG_DIR/*.log* $LAST_LOG_DIR."1"
 
 
 DATE=$(date +%Y%m%d%H%M)
 
 cat /proc/last_kmsg > $LOG_DIR/"$DATE"_last_kmsg.log
 
 echo "------start kmsg log------"
 cat /proc/kmsg > $LOG_DIR/"$DATE"_kmsg.log &
 
 echo "------start logcat log------"
 logcat -v time -n 1 -f $LOG_DIR/"$DATE"_logcat.log -r10240 
 

