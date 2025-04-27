import React from 'react';
import {
	Avatar,
	List,
	ListItem,
	ListItemAvatar,
	ListItemText,
	Grid,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import moment from 'moment';
import { useSelector } from 'react-redux';
import { useHistory } from 'react-router';

const useStyles = makeStyles((theme) => ({
	wrapper: {
		padding: '20px 10px 20px 20px',
		borderBottom: `1px solid ${theme.palette.border.divider}`,
		'&:first-of-type': {
			borderTop: `1px solid ${theme.palette.border.divider}`,
		},
	},
	mugshot: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		margin: 'auto',
		height: 60,
		width: 60,
	}
}));

const Admin = ({ admin }) => {
    const classes = useStyles();
    const history = useHistory();

    const handleAdminClick = () => {
        if (!admin.Identifier) {
            return;
        }
        history.push(`/admin/${admin.Identifier}`);
    };

    return (
        <ListItem className={classes.adminItem} button onClick={handleAdminClick}>
            <Grid container>
                <Grid item xs={3}>
                    <ListItemText primary="Admin Name" secondary={admin.Name} />
                </Grid>
                <Grid item xs={3}>
                    <ListItemText primary="Source" secondary={admin.Source} />
                </Grid>
                <Grid item xs={3}>
                    <ListItemText primary="Identifier" secondary={admin.Identifier} />
                </Grid>
                <Grid item xs={3}>
                    <ListItemText primary="Status" secondary={admin.Status || 'Offline'} />
                </Grid>
                <Grid item xs={3}>
                    <ListItemText primary="AP (Admin Points)" secondary={admin.AP || 'N/A'} />
                </Grid>
            </Grid>
        </ListItem>
    );
};

export default Admin;
