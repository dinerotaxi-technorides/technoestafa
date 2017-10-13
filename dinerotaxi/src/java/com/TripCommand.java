package com;

import java.util.Date;

public class TripCommand {

	Long opid;
	String creationDate;
	String placeFrom, piso, depto, placeTo, comments, status,
			favoriteName = "";
	Long timeTravel;

	TaxiCommand taxista;

	TripCommand(Long opid, Long timeTravel, Date creationDate,
			String placeFrom, String piso, String depto, String placeTo,
			String comments, String status, TaxiCommand taxista) {
		this.opid = opid;
		this.creationDate =new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(creationDate) ;
		this.placeFrom = placeFrom;
		this.piso = piso;
		this.depto = depto;
		this.placeTo = placeTo;
		this.comments = comments;
		this.status = status;
		this.taxista = taxista;
		this.timeTravel = timeTravel;
	}

	TripCommand(Long opid, Long timeTravel, Date creationDate,
			String placeFrom, String piso, String depto, String placeTo,
			String comments, String status, TaxiCommand taxista,
			String favoriteName) {
		this.opid = opid;
		this.creationDate = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(creationDate) ;
		this.placeFrom = placeFrom;
		this.piso = piso;
		this.depto = depto;
		this.placeTo = placeTo;
		this.comments = comments;
		this.status = status;
		this.taxista = taxista;
		this.favoriteName = favoriteName;
		this.timeTravel = timeTravel;
	}

	public String getFavoriteName() {
		return favoriteName;
	}

	public void setFavoriteName(String favoriteName) {
		this.favoriteName = favoriteName;
	}

	public Long getTimeTravel() {
		return timeTravel;
	}

	public void setTimeTravel(Long timeTravel) {
		this.timeTravel = timeTravel;
	}

	public TaxiCommand getTaxista() {
		return taxista;
	}

	public void setTaxista(TaxiCommand taxista) {
		this.taxista = taxista;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getOpid() {
		return opid;
	}

	public void setOpid(Long opid) {
		this.opid = opid;
	}

	public String getCreationDate() {
		return creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(creationDate);
	}

	public void setCreationDate(String creationDate) {
		this.creationDate = creationDate;
	}

	public String getPlaceFrom() {
		return placeFrom;
	}

	public void setPlaceFrom(String placeFrom) {
		this.placeFrom = placeFrom;
	}

	public String getPiso() {
		return piso;
	}

	public void setPiso(String piso) {
		this.piso = piso;
	}

	public String getDepto() {
		return depto;
	}

	public void setDepto(String depto) {
		this.depto = depto;
	}

	public String getPlaceTo() {
		return placeTo;
	}

	public void setPlaceTo(String placeTo) {
		this.placeTo = placeTo;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}
}
