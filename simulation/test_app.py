import sys
from PyQt5.QtWidgets import QApplication, QWidget, QLabel

def main():
    # Create an application instance
    app = QApplication(sys.argv)

    # Create a QWidget (a simple window)
    window = QWidget()
    window.setWindowTitle('PyQt5 Window')

    # Create a QLabel widget (to display text)
    label = QLabel('Ok, works!', parent=window)
    label.move(100, 100)  # Position the text inside the window

    # Set the size of the window and show it
    window.resize(300, 200)
    window.show()

    # Start the application's event loop
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
