(in-package :greed)
;players.lisp
; Here go the classes for the players, state etc
(defclass state () 
  ((score :reader get-score :writer set-score 
          :accessor score :initarg :score :initform 0)
   (dice :reader get-dice :writer set-dice :initarg :dice :initform 5)
   (turns :accessor turns :initform 0)
   (turn-wins :accessor turn-wins :initform 0)
   (turn-lost :accessor turn-lost :initform 0)
   (total-turn-score :accessor total-turn-score :initform 0)
   (total-lost-score :accessor total-lost-score :initform 0)))

(defclass player ()
  ((state :accessor state :initform (make-instance 'state) :type 'state)
   (name :reader get-name :initarg :name 
         :initform (error "no name given") :type 'string)))

(defclass human (player) ())

(defgeneric print-stats (player)
  (:documentation "Print the stats for a single player. Return as string."))

(defmethod print-stats (player)
  (with-slots (state) player
    (if (zerop (turns state))
      (format t "~a has a score of 0." (get-name player))
      (format t 
              " == STATS == 
               Name: ~a
               Total score: ~a
               Rolls lost: ~a
               Rolls win: ~a
               Average successful turn score: ~a
               Average turn score lost: ~a"
              (get-name player)
              (get-score state)
              (turn-lost state)
              (turn-wins state)
              (floor (/ (total-turn-score state) (turn-wins state)))
              (floor (/ (total-lost-score state) (turn-lost state)))))))

(defgeneric get-choice (turn-score dice num-dice player)
  (:documentation "prompts the player to continue or not"))

(defmethod get-choice (turn-score dice num-dice (pl human))
  (yes-or-no-p " PLAYER: ~a ~% DICE: ~a ~%Current roll score: ~a ~%Remaining dice: ~a~%Keep rolling? "
               (get-name pl) dice turn-score num-dice))

(defgeneric message-roll-fail (score dice player)
  (:documentation "message a failed roll to a player."))

(defmethod message-roll-fail (score dice (player human)) 
  (format t " PLAYER: ~a ~% DICE: ~a ~%Current roll score: ~a ~% YOU LOST IT ALL."
          (get-name player) dice score))

