import numpy as np
import pandas as pd
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
#import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func, inspect
from sqlalchemy.pool import SingletonThreadPool



import datetime as dt
from datetime import datetime
from dateutil.relativedelta import relativedelta


#################################################
# Database Setup
#################################################

engine = create_engine("sqlite:///Resources/hawaii.sqlite",poolclass=SingletonThreadPool)

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
		f"/api/v1.0/tobs<br/>"
		f"/api/v1.0/startdate/<start><br/>"
		f"/api/v1.0/startenddates/<start>/<end>"
	)


@app.route("/api/v1.0/precipitation")
def precipitation():
    """Convert the query results to a Dictionary using `date` as the key and `prcp` as the value"""
# Query  precipations
    all_precip =[]
    results = session.query(Measurement.prcp,Measurement.date).order_by(Measurement.date.desc()).all()
	
    for result in results:
        precip_dict ={}
        precip_dict["date"] = result.date
        precip_dict["prcp"] = result.prcp
        all_precip.append(precip_dict)

    return jsonify(all_precip)


@app.route("/api/v1.0/stations")
def stations():
    """Return a JSON list of stations from the dataset"""
    # Query all stations
    stresults = session.query(Station.station).distinct(Station.station)
        # Create a dictionary from the row data and append to a list of stations
    all_station =[]
    for result in stresults:
        station_dict ={}
        station_dict["station"] = result.station
        
        all_station.append(station_dict)

    return jsonify(all_station)
    

@app.route("/api/v1.0/tobs")
def tobs():
    """Returns a list of temperature observations from the last year in JSON format """
    last_entry_date = np.ravel(session.query(Measurement.date).order_by(Measurement.date.desc()).limit(1).all())

    current_date= datetime.strptime(last_entry_date[0], '%Y-%m-%d')
	# Calculate the date 1 year ago from the last data point in the database
    last_twelve_months = current_date + relativedelta(months=-12)

    #Query database for tobs for last year
    tobs_data_12m = session.query(Measurement.date,Measurement.tobs).filter(Measurement.date > last_twelve_months).all()
    
    # Convert the list of tuples into normal list:
    all_tobs =[]
    for result in tobs_data_12m:
        tobs_dict ={}
        tobs_dict["date"] = result.date
        tobs_dict["tobs"] = result.tobs
        all_tobs.append(tobs_dict)

    return jsonify(all_tobs)

    
    
	
@app.route("/api/v1.0/startdate/<start>")
def trip1(start):

 # go back one year from start date and go to end of data for Min/Avg/Max temp   
	
    start_date= datetime.strptime(start, '%Y-%m-%d')
    sdate = start_date + relativedelta(months=-12)

    trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= sdate).all()
    #trip = list(np.ravel(trip_data))

    s_tobs =[]
    for result in trip_data:
        stobs_dict ={}
        stobs_dict["Min Temp"] = result[0]
        stobs_dict["Average Temp"] = round(result[1])
        stobs_dict["Max Temp"] = result[2]
        s_tobs.append(stobs_dict)
    return jsonify(s_tobs)

@app.route("/api/v1.0/startenddates/<start>/<end>")
def trip2(start,end):

  # go back one year from start/end date and get Min/Avg/Max temp 
    start_date= datetime.strptime(start, '%Y-%m-%d')
    sdate = start_date + relativedelta(months=-12)
	
    end_date= datetime.strptime(end, '%Y-%m-%d')
    edate = end_date + relativedelta(months=-12)

       
    SE_trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= sdate).filter(Measurement.date <= edate).all()
    #trip = list(np.ravel(trip_data))
    
    se_tobs =[]
    for result in SE_trip_data:
        setobs_dict ={}
        setobs_dict["Min Temp"] = result[0]
        setobs_dict["Average Temp"] = round(result[1])
        setobs_dict["Max Temp"] = result[2]
        se_tobs.append(setobs_dict)
    return jsonify(se_tobs)
    
    
    return jsonify(trip)


if __name__ == '__main__':
    app.run(debug=True)
