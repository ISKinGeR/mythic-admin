import React, { useEffect, useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import {
    TableContainer,
    Table,
    TableHead,
    TableRow,
    TableCell,
    TableBody,
    Paper,
    TextField,
    InputAdornment,
    IconButton,
    Pagination,
    Avatar,
    Grid,
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import moment from 'moment';
import Nui from '../../util/Nui';
import { Loader } from '../../components';
import { useHistory } from 'react-router';

const useStyles = makeStyles((theme) => ({
    wrapper: {
        padding: '20px',
        height: '100%',
    },
    search: {
        marginBottom: theme.spacing(2),
    },
    tableContainer: {
        boxShadow: 'none',
        backgroundColor: 'transparent',
        maxHeight: 'calc(100% - 120px)',
        overflow: 'auto',
    },
    tableRow: {
        '&:hover': {
            backgroundColor: theme.palette.action.hover,
            cursor: 'pointer',
        },
    },
    avatarCell: {
        display: 'flex',
        alignItems: 'center',
    },
    avatar: {
        marginRight: theme.spacing(2),
        width: theme.spacing(4),
        height: theme.spacing(4),
    },
    pagination: {
        marginTop: theme.spacing(2),
        display: 'flex',
        justifyContent: 'center',
    },
    characterName: {
        color: theme.palette.text.secondary,
    },
    disconnectedText: {
        color: theme.palette.error.main,
    },
    reconnectedText: {
        color: theme.palette.success.main,
    },
}));

const DisconnectedPlayerList = (props) => {
    const classes = useStyles();
    const history = useHistory();
    const dispatch = useDispatch();
    const PER_PAGE = 15;

    const [searched, setSearched] = useState('');
    const [pages, setPages] = useState(1);
    const [page, setPage] = useState(1);
    const [loading, setLoading] = useState(false);
    const [results, setResults] = useState([]);
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        fetch();
        const interval = setInterval(() => fetch(), 60 * 1000);
        return () => clearInterval(interval);
    }, []);

    useEffect(() => {
        setPages(Math.ceil(players.length / PER_PAGE));
    }, [players]);

    useEffect(() => {
        setPlayers(
            results.filter((r) => {
                const nameMatch = r.Name?.toLowerCase().includes(searched?.toLowerCase() || '');
                const charNameMatch = r.Character 
                    ? `${r.Character.First || ''} ${r.Character.Last || ''}`.toLowerCase().includes(searched?.toLowerCase() || '') 
                    : false;
                const accountMatch = r.AccountID == parseInt(searched || '');
                const sidMatch = r.Character?.SID == parseInt(searched || '');
    
                return nameMatch || accountMatch || charNameMatch || sidMatch;
            })
        );
    }, [results, searched]);

    const fetch = async () => {
        setLoading(true);
        try {
            let res = await(await Nui.send('GetPlayerList', {
                disconnected: true
            })).json();
            if (res) setResults(res);
        } catch(e) {
            // Fallback data if needed
        }
        setLoading(false);
    };

    const onClear = () => setSearched('');
    const onPagi = (e, p) => setPage(p);

    const handlePlayerClick = (player) => {
        history.push(`/player/${player.Source}`);
    };

    const formatDisconnectedTime = (timestamp) => {
        return moment(timestamp * 1000).fromNow();
    };

    return (
        <div className={classes.wrapper}>
            <Grid container spacing={2} className={classes.search}>
                <Grid item xs={12}>
                    <TextField
                        fullWidth
                        variant="outlined"
                        name="search"
                        value={searched}
                        onChange={(e) => setSearched(e.target.value)}
                        label="Search"
                        InputProps={{
                            endAdornment: (
                                <InputAdornment position="end">
                                    {searched != '' && (
                                        <IconButton type="button" onClick={onClear}>
                                            <FontAwesomeIcon icon={['fas', 'xmark']} />
                                        </IconButton>
                                    )}
                                </InputAdornment>
                            ),
                        }}
                    />
                </Grid>
            </Grid>

            {loading ? (
                <Loader text="Loading" />
            ) : (
                <>
                    <TableContainer component={Paper} className={classes.tableContainer}>
                        <Table stickyHeader aria-label="disconnected players table">
                            <TableHead>
                                <TableRow>
                                    <TableCell>Account ID</TableCell>
                                    <TableCell>Player</TableCell>
                                    <TableCell>Character</TableCell>
                                    <TableCell>Status</TableCell>
                                    <TableCell>Disconnected</TableCell>
                                </TableRow>
                            </TableHead>
                            <TableBody>
                                {players
                                    .sort((a, b) => b.DisconnectedTime - a.DisconnectedTime)
                                    .slice((page - 1) * PER_PAGE, page * PER_PAGE)
                                    .map((player) => (
                                        <TableRow 
                                            key={player.Source} 
                                            className={classes.tableRow}
                                            onClick={() => handlePlayerClick(player)}
                                        >
                                            <TableCell>{player.AccountID}</TableCell>
                                            <TableCell>
                                                <div className={classes.avatarCell}>
                                                    <Avatar className={classes.avatar}>
                                                        {player.Name?.charAt(0)}
                                                    </Avatar>
                                                    {player.Name}
                                                </div>
                                            </TableCell>
                                            <TableCell>
                                                {player.Character ? (
                                                    <>
                                                        {player.Character.First} {player.Character.Last}
                                                        <div className={classes.characterName}>
                                                            SID: {player.Character.SID}
                                                        </div>
                                                    </>
                                                ) : (
                                                    'Not Logged In'
                                                )}
                                            </TableCell>
                                            <TableCell className={player.Reconnected ? classes.reconnectedText : classes.disconnectedText}>
                                                {player.Reconnected ? 'Reconnected' : 'Disconnected'}
                                            </TableCell>
                                            <TableCell>
                                                {formatDisconnectedTime(player.DisconnectedTime)}
                                                {player.Reconnected && (
                                                    <div className={classes.reconnectedText}>
                                                        Reconnected {player.Reconnected} time(s)
                                                    </div>
                                                )}
                                            </TableCell>
                                        </TableRow>
                                    ))}
                            </TableBody>
                        </Table>
                    </TableContainer>

                    {pages > 1 && (
                        <div className={classes.pagination}>
                            <Pagination
                                variant="outlined"
                                shape="rounded"
                                color="primary"
                                page={page}
                                count={pages}
                                onChange={onPagi}
                            />
                        </div>
                    )}
                </>
            )}
        </div>
    );
};

export default DisconnectedPlayerList;