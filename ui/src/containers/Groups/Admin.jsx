import React from 'react';
import { useSelector } from 'react-redux';
import { Grid } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { Route, Switch } from 'react-router';

import links from './links';
import { Navbar, Modal } from '../../components';

import {
	Error,
	Dashboard,
	Players,
	DisconnectedPlayers,
	PlayerView,
	CurrentVehicle,
	DevTestPlace,
} from '../../pages';
import Commands from '../../pages/Commands'; 
import AdminList from '../../pages/AdminList';
import AdminView from '../../pages/View/Admin';
import Titlebar from '../../components/Titlebar';

const useStyles = makeStyles((theme) => ({
	container: {
		height: '100%',
	},
	wrapper: {
		height: '100%',
	},
	content: {
		height: '100%',
		overflowY: 'auto',
		overflowX: 'hidden',
	},
	maxHeight: {
		height: 'calc(100% - 86px)',
	},
	noCallsign: {
		position: 'absolute',
		height: 'fit-content',
		width: 'fit-content',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
	}
}));

export default () => {
	const classes = useStyles();
	const permissionName = useSelector((state) => state.app.permission);

	return (
		<div className={classes.container}>
            <Grid container className={classes.maxHeight}>
                <Grid item xs={12}>
                    <Titlebar />
                </Grid>
                <Grid item xs={3} className={classes.wrapper}>
                    <Navbar links={links(permissionName)} />
                </Grid>
                <Grid item xs={9} className={classes.wrapper}>
                    <div className={classes.content}>
                        <Switch>
                            <Route exact path="/" component={Dashboard} />
							<Route exact path="/players" component={Players} />
							<Route exact path="/commands" component={Commands} />
							<Route exact path="/AdminList" component={AdminList} />
							<Route exact path="/disconnected-players" component={DisconnectedPlayers} />
							<Route exact path="/current-vehicle" component={CurrentVehicle} />
							<Route exact path="/Devtools" component={DevTestPlace} />
							<Route exact path="/player/:id" component={PlayerView} />
							<Route exact path="/admin/:id" component={AdminView} />
                            <Route component={Error} />
                        </Switch>
                    </div>
                </Grid>
            </Grid>
		</div>
	);
};
