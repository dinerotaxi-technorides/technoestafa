package com

import ar.com.goliath.MailQueue
import ar.com.goliath.MailQueueStatus
class EmailService {
  def mailService
  def jmsService
  
  static expose = ['jms']
  
  void onMessage(msg) {
    //Thread.currentThread().sleep(0.1*1000)
    //def mail = MailQueue.get(msg.id)
    
    def mail = new MailQueue(to: msg.to, from: msg.from, subject: msg.subject, body: msg.body)
    
    if(mail){
      mailService.sendMail {
        to mail.to
        from mail.from
        subject mail.subject
        html mail.body
      }
      mail.status = MailQueueStatus.SENT
      mail.save(flush:true)
    }
    else{
      mail.status = MailQueueStatus.FAILED
      mail.save(flush:true)    
    }
    
    log.info( "Email sent ${mail.to}") 
  }

  boolean send(String to, String from, String subject, String body){
    jmsService.send("dinerotaxi.email", [to: to, from: from, subject: subject, body: body], null)
    return true
  }
  
}

