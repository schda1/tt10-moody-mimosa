# Form implementation generated from reading ui file 'app.ui'
#
# Created by: PyQt6 UI code generator 6.4.2
#
# WARNING: Any manual changes made to this file will be lost when pyuic6 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt6 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1097, 591)
        self.centralwidget = QtWidgets.QWidget(parent=MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayoutWidget_2 = QtWidgets.QWidget(parent=self.centralwidget)
        self.gridLayoutWidget_2.setGeometry(QtCore.QRect(210, 10, 151, 44))
        self.gridLayoutWidget_2.setObjectName("gridLayoutWidget_2")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.gridLayoutWidget_2)
        self.gridLayout_2.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.label = QtWidgets.QLabel(parent=self.gridLayoutWidget_2)
        self.label.setObjectName("label")
        self.gridLayout_2.addWidget(self.label, 0, 0, 1, 1)
        self.led_heartbeat = QtWidgets.QPushButton(parent=self.gridLayoutWidget_2)
        self.led_heartbeat.setMaximumSize(QtCore.QSize(50, 25))
        self.led_heartbeat.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.led_heartbeat.setText("")
        self.led_heartbeat.setCheckable(True)
        self.led_heartbeat.setChecked(False)
        self.led_heartbeat.setObjectName("led_heartbeat")
        self.gridLayout_2.addWidget(self.led_heartbeat, 0, 1, 1, 1)
        self.gridLayoutWidget_3 = QtWidgets.QWidget(parent=self.centralwidget)
        self.gridLayoutWidget_3.setGeometry(QtCore.QRect(210, 70, 151, 301))
        self.gridLayoutWidget_3.setObjectName("gridLayoutWidget_3")
        self.gridLayout_3 = QtWidgets.QGridLayout(self.gridLayoutWidget_3)
        self.gridLayout_3.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.label_3 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_3.setObjectName("label_3")
        self.gridLayout_3.addWidget(self.label_3, 0, 0, 1, 1)
        self.led_em_happy = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_happy.setMaximumSize(QtCore.QSize(50, 16777215))
        self.led_em_happy.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.led_em_happy.setText("")
        self.led_em_happy.setCheckable(True)
        self.led_em_happy.setChecked(False)
        self.led_em_happy.setObjectName("led_em_happy")
        self.gridLayout_3.addWidget(self.led_em_happy, 0, 1, 1, 1)
        self.led_em_angry = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_angry.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(240,104,6); /* Background color when checked */\n"
"}")
        self.led_em_angry.setText("")
        self.led_em_angry.setCheckable(True)
        self.led_em_angry.setChecked(False)
        self.led_em_angry.setObjectName("led_em_angry")
        self.gridLayout_3.addWidget(self.led_em_angry, 5, 1, 1, 1)
        self.led_em_nervous = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_nervous.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(240,104,6); /* Background color when checked */\n"
"}")
        self.led_em_nervous.setText("")
        self.led_em_nervous.setCheckable(True)
        self.led_em_nervous.setChecked(False)
        self.led_em_nervous.setObjectName("led_em_nervous")
        self.gridLayout_3.addWidget(self.led_em_nervous, 6, 1, 1, 1)
        self.led_em_bored = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_bored.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(252,232,9); /* Background color when checked */\n"
"}")
        self.led_em_bored.setText("")
        self.led_em_bored.setCheckable(True)
        self.led_em_bored.setChecked(False)
        self.led_em_bored.setObjectName("led_em_bored")
        self.gridLayout_3.addWidget(self.led_em_bored, 3, 1, 1, 1)
        self.label_4 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_4.setObjectName("label_4")
        self.gridLayout_3.addWidget(self.label_4, 2, 0, 1, 1)
        self.label_5 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_5.setObjectName("label_5")
        self.gridLayout_3.addWidget(self.label_5, 3, 0, 1, 1)
        self.led_em_excited = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_excited.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.led_em_excited.setText("")
        self.led_em_excited.setCheckable(True)
        self.led_em_excited.setChecked(False)
        self.led_em_excited.setObjectName("led_em_excited")
        self.gridLayout_3.addWidget(self.led_em_excited, 2, 1, 1, 1)
        self.led_em_tired = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_tired.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(252,232,9); /* Background color when checked */\n"
"}")
        self.led_em_tired.setText("")
        self.led_em_tired.setCheckable(True)
        self.led_em_tired.setChecked(False)
        self.led_em_tired.setObjectName("led_em_tired")
        self.gridLayout_3.addWidget(self.led_em_tired, 4, 1, 1, 1)
        self.led_em_comfortable = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_comfortable.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.led_em_comfortable.setText("")
        self.led_em_comfortable.setCheckable(True)
        self.led_em_comfortable.setChecked(False)
        self.led_em_comfortable.setObjectName("led_em_comfortable")
        self.gridLayout_3.addWidget(self.led_em_comfortable, 1, 1, 1, 1)
        self.label_8 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_8.setObjectName("label_8")
        self.gridLayout_3.addWidget(self.label_8, 6, 0, 1, 1)
        self.label_2 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_2.setObjectName("label_2")
        self.gridLayout_3.addWidget(self.label_2, 1, 0, 1, 1)
        self.label_7 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_7.setObjectName("label_7")
        self.gridLayout_3.addWidget(self.label_7, 5, 0, 1, 1)
        self.label_6 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_6.setObjectName("label_6")
        self.gridLayout_3.addWidget(self.label_6, 4, 0, 1, 1)
        self.label_9 = QtWidgets.QLabel(parent=self.gridLayoutWidget_3)
        self.label_9.setObjectName("label_9")
        self.gridLayout_3.addWidget(self.label_9, 7, 0, 1, 1)
        self.led_em_stressed = QtWidgets.QPushButton(parent=self.gridLayoutWidget_3)
        self.led_em_stressed.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(240,104,6); /* Background color when checked */\n"
"}")
        self.led_em_stressed.setText("")
        self.led_em_stressed.setCheckable(True)
        self.led_em_stressed.setChecked(False)
        self.led_em_stressed.setObjectName("led_em_stressed")
        self.gridLayout_3.addWidget(self.led_em_stressed, 7, 1, 1, 1)
        self.gridLayoutWidget_4 = QtWidgets.QWidget(parent=self.centralwidget)
        self.gridLayoutWidget_4.setGeometry(QtCore.QRect(210, 400, 151, 131))
        self.gridLayoutWidget_4.setObjectName("gridLayoutWidget_4")
        self.gridLayout_5 = QtWidgets.QGridLayout(self.gridLayoutWidget_4)
        self.gridLayout_5.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_5.setObjectName("gridLayout_5")
        self.label_12 = QtWidgets.QLabel(parent=self.gridLayoutWidget_4)
        self.label_12.setObjectName("label_12")
        self.gridLayout_5.addWidget(self.label_12, 1, 0, 1, 1)
        self.label_13 = QtWidgets.QLabel(parent=self.gridLayoutWidget_4)
        self.label_13.setObjectName("label_13")
        self.gridLayout_5.addWidget(self.label_13, 2, 0, 1, 1)
        self.led_st_asleep = QtWidgets.QPushButton(parent=self.gridLayoutWidget_4)
        self.led_st_asleep.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(30,165,240); /* Background color when checked */\n"
"}")
        self.led_st_asleep.setText("")
        self.led_st_asleep.setCheckable(True)
        self.led_st_asleep.setChecked(False)
        self.led_st_asleep.setObjectName("led_st_asleep")
        self.gridLayout_5.addWidget(self.led_st_asleep, 1, 1, 1, 1)
        self.led_st_awake = QtWidgets.QPushButton(parent=self.gridLayoutWidget_4)
        self.led_st_awake.setMaximumSize(QtCore.QSize(50, 16777215))
        self.led_st_awake.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(30,165,240); /* Background color when checked */\n"
"}")
        self.led_st_awake.setText("")
        self.led_st_awake.setCheckable(True)
        self.led_st_awake.setChecked(False)
        self.led_st_awake.setObjectName("led_st_awake")
        self.gridLayout_5.addWidget(self.led_st_awake, 0, 1, 1, 1)
        self.label_11 = QtWidgets.QLabel(parent=self.gridLayoutWidget_4)
        self.label_11.setObjectName("label_11")
        self.gridLayout_5.addWidget(self.label_11, 0, 0, 1, 1)
        self.led_st_dying = QtWidgets.QPushButton(parent=self.gridLayoutWidget_4)
        self.led_st_dying.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(230,8,3) /* Background color when checked */\n"
"}")
        self.led_st_dying.setText("")
        self.led_st_dying.setCheckable(True)
        self.led_st_dying.setChecked(False)
        self.led_st_dying.setObjectName("led_st_dying")
        self.gridLayout_5.addWidget(self.led_st_dying, 2, 1, 1, 1)
        self.led_st_dead = QtWidgets.QPushButton(parent=self.gridLayoutWidget_4)
        self.led_st_dead.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(117,3,1) /* Background color when checked */\n"
"}")
        self.led_st_dead.setText("")
        self.led_st_dead.setCheckable(True)
        self.led_st_dead.setChecked(False)
        self.led_st_dead.setObjectName("led_st_dead")
        self.gridLayout_5.addWidget(self.led_st_dead, 3, 1, 1, 1)
        self.label_14 = QtWidgets.QLabel(parent=self.gridLayoutWidget_4)
        self.label_14.setObjectName("label_14")
        self.gridLayout_5.addWidget(self.label_14, 3, 0, 1, 1)
        self.plotFrame = QtWidgets.QFrame(parent=self.centralwidget)
        self.plotFrame.setGeometry(QtCore.QRect(400, 10, 671, 521))
        self.plotFrame.setFrameShape(QtWidgets.QFrame.Shape.StyledPanel)
        self.plotFrame.setFrameShadow(QtWidgets.QFrame.Shadow.Raised)
        self.plotFrame.setObjectName("plotFrame")
        self.verticalLayoutWidget = QtWidgets.QWidget(parent=self.centralwidget)
        self.verticalLayoutWidget.setGeometry(QtCore.QRect(20, 160, 111, 271))
        self.verticalLayoutWidget.setObjectName("verticalLayoutWidget")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.verticalLayoutWidget)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.button_tickle = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_tickle.setMaximumSize(QtCore.QSize(100, 25))
        self.button_tickle.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_tickle.setCheckable(True)
        self.button_tickle.setChecked(False)
        self.button_tickle.setObjectName("button_tickle")
        self.verticalLayout.addWidget(self.button_tickle)
        self.button_feed = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_feed.setMaximumSize(QtCore.QSize(100, 25))
        self.button_feed.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_feed.setCheckable(True)
        self.button_feed.setChecked(False)
        self.button_feed.setObjectName("button_feed")
        self.verticalLayout.addWidget(self.button_feed)
        self.button_too_hot = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_too_hot.setMaximumSize(QtCore.QSize(100, 25))
        self.button_too_hot.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_too_hot.setCheckable(True)
        self.button_too_hot.setChecked(False)
        self.button_too_hot.setObjectName("button_too_hot")
        self.verticalLayout.addWidget(self.button_too_hot)
        self.button_too_loud = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_too_loud.setMaximumSize(QtCore.QSize(100, 25))
        self.button_too_loud.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_too_loud.setCheckable(True)
        self.button_too_loud.setChecked(False)
        self.button_too_loud.setObjectName("button_too_loud")
        self.verticalLayout.addWidget(self.button_too_loud)
        self.button_too_calm = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_too_calm.setMaximumSize(QtCore.QSize(100, 25))
        self.button_too_calm.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_too_calm.setCheckable(True)
        self.button_too_calm.setChecked(False)
        self.button_too_calm.setObjectName("button_too_calm")
        self.verticalLayout.addWidget(self.button_too_calm)
        self.button_too_bright = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_too_bright.setMaximumSize(QtCore.QSize(100, 25))
        self.button_too_bright.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_too_bright.setCheckable(True)
        self.button_too_bright.setChecked(False)
        self.button_too_bright.setObjectName("button_too_bright")
        self.verticalLayout.addWidget(self.button_too_bright)
        self.button_reanimate = QtWidgets.QPushButton(parent=self.verticalLayoutWidget)
        self.button_reanimate.setMaximumSize(QtCore.QSize(100, 25))
        self.button_reanimate.setStyleSheet("QPushButton {\n"
"    background-color: white; /* Normal background color */\n"
"}\n"
"\n"
"QPushButton:checked {\n"
"    background-color: rgb(34,177,76); /* Background color when checked */\n"
"}")
        self.button_reanimate.setCheckable(True)
        self.button_reanimate.setChecked(False)
        self.button_reanimate.setObjectName("button_reanimate")
        self.verticalLayout.addWidget(self.button_reanimate)
        self.slider_sim_speed = QtWidgets.QSlider(parent=self.centralwidget)
        self.slider_sim_speed.setGeometry(QtCore.QRect(10, 510, 141, 16))
        self.slider_sim_speed.setOrientation(QtCore.Qt.Orientation.Horizontal)
        self.slider_sim_speed.setObjectName("slider_sim_speed")
        self.label_15 = QtWidgets.QLabel(parent=self.centralwidget)
        self.label_15.setGeometry(QtCore.QRect(10, 480, 121, 25))
        self.label_15.setObjectName("label_15")
        self.label_16 = QtWidgets.QLabel(parent=self.centralwidget)
        self.label_16.setGeometry(QtCore.QRect(10, 10, 131, 51))
        self.label_16.setWordWrap(True)
        self.label_16.setObjectName("label_16")
        self.pushButton = QtWidgets.QPushButton(parent=self.centralwidget)
        self.pushButton.setGeometry(QtCore.QRect(40, 100, 80, 22))
        self.pushButton.setObjectName("pushButton")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(parent=MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 1097, 19))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(parent=MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label.setText(_translate("MainWindow", "Heartbeat"))
        self.label_3.setText(_translate("MainWindow", "Happy"))
        self.label_4.setText(_translate("MainWindow", "Excited"))
        self.label_5.setText(_translate("MainWindow", "Bored"))
        self.label_8.setText(_translate("MainWindow", "Nervous"))
        self.label_2.setText(_translate("MainWindow", "Comfortable"))
        self.label_7.setText(_translate("MainWindow", "Angry"))
        self.label_6.setText(_translate("MainWindow", "Tired"))
        self.label_9.setText(_translate("MainWindow", "Stressed"))
        self.label_12.setText(_translate("MainWindow", "Sleeping"))
        self.label_13.setText(_translate("MainWindow", "Dying"))
        self.label_11.setText(_translate("MainWindow", "Awake"))
        self.label_14.setText(_translate("MainWindow", "Dead"))
        self.button_tickle.setText(_translate("MainWindow", "Tickle"))
        self.button_feed.setText(_translate("MainWindow", "Feed"))
        self.button_too_hot.setText(_translate("MainWindow", "Too hot"))
        self.button_too_loud.setText(_translate("MainWindow", "Too loud"))
        self.button_too_calm.setText(_translate("MainWindow", "Too calm"))
        self.button_too_bright.setText(_translate("MainWindow", "Too bright"))
        self.button_reanimate.setText(_translate("MainWindow", "Reanimate"))
        self.label_15.setText(_translate("MainWindow", "Simulation speed"))
        self.label_16.setText(_translate("MainWindow", "Moody Mimosa Simulator"))
        self.pushButton.setText(_translate("MainWindow", "PushButton"))