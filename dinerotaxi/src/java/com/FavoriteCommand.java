package com;

import java.util.Date;


public class FavoriteCommand {
	
	Long id;
	Date creationDate;
	String placeFrom,piso,depto;
	String name;

	FavoriteCommand(Long id,Date creationDate,String placeFrom,String piso,String depto,String name){
		 this.id=id;
		 this.creationDate=creationDate;
		 this.placeFrom=placeFrom;
		 this.piso=piso;
		 this.depto=depto;
		 this.name=name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getCreationDate() {
		return creationDate;
	}
	public void setCreationDate(Date creationDate) {
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
	
}
