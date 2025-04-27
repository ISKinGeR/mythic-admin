import React, { useEffect, useState } from 'react';
import { 
  Grid, 
  Box, 
  Avatar, 
  Typography, 
  TextField, 
  IconButton, 
  InputAdornment,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Paper,
  InputBase,
  Divider
} from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import Clear from '@material-ui/icons/Clear';
import SearchIcon from '@material-ui/icons/Search';
import Nui from '../../util/Nui';

const DEFAULT_PED = 'mp_m_freemode_01';

const ALL_PEDS = [
	'mp_m_freemode_01',
	'mp_f_freemode_01',
  ];


const useStyles = makeStyles((theme) => ({
wrapper: {
	padding: '20px 10px 20px 20px',
	height: '100%',
	},
  pedSection: {
    padding: theme.spacing(2),
    backgroundColor: theme.palette.background.paper,
    borderRadius: theme.shape.borderRadius,
    height: '100%',
  },
  pedPreview: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
    cursor: 'pointer',
    '&:hover': { opacity: 0.8 }
  },
  currentPedImage: {
    width: 100,
    height: 100,
    marginBottom: theme.spacing(1),
    '& img': {
      objectFit: 'contain',
      width: '100%',
      height: '100%'
    }
  },
  pedControls: { display: 'grid', gap: theme.spacing(2) },
  compactButtonGroup: {
    display: 'flex',
    gap: theme.spacing(1),
    marginTop: theme.spacing(1)
  },
  pedGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(120px, 1fr))',
    gap: theme.spacing(2),
    maxHeight: '60vh',
    overflowY: 'auto',
    padding: theme.spacing(1)
  },
  pedItem: {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    cursor: 'pointer',
    padding: theme.spacing(1),
    '&:hover': { backgroundColor: theme.palette.action.hover }
  },
  pedAvatar: {
    width: 100,
    height: 100,
    '& img': {
      objectFit: 'contain',
      width: '100%',
      height: '100%'
    }
  }
}));

export default function PedManager() {
  const classes = useStyles();
  const [currentPedModel, setCurrentPedModel] = useState(DEFAULT_PED);
  const [selectedPed, setSelectedPed] = useState("");
  const [playerSource, setPlayerSource] = useState("");
  const [openPedSelector, setOpenPedSelector] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [pedList, setPedList] = useState([]);

  useEffect(() => {
    Nui.send("getCurrentPedModel").then((model) => {
      setCurrentPedModel(typeof model === "string" ? model : DEFAULT_PED);
    });

	Nui.send("zsetped:choices:ped").then((models) => {
		if (Array.isArray(models)) {
		  setPedList(models);
		} else {
		  console.error("Received invalid ped models data:", models);
		  setPedList(ALL_PEDS);
		}
	  }).catch((error) => {
		console.error("Failed to fetch ped models:", error);
		setPedList(ALL_PEDS);
	});
  }, []);

  const getPedImageUrl = (model) => 
    `https://docs.fivem.net/peds/${(model || DEFAULT_PED).toLowerCase()}.webp`;

  const handleSetCurrentPed = () => {
    if (!selectedPed) return;
    Nui.send("zsetped", { ped: selectedPed });
    setCurrentPedModel(selectedPed);
  };

  const handleSetPlayerPed = () => {
    if (!selectedPed || !playerSource) return;
    Nui.send("setPlayerPed", { ped: selectedPed, player: playerSource });
  };

  const handleResetPed = () => {
    setSelectedPed("");
    Nui.send("setCurrentPed", { model: DEFAULT_PED });
    setCurrentPedModel(DEFAULT_PED);
  };

  const filteredPeds = pedList.filter(ped => 
    ped.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
	<div className={classes.wrapper}>
		<Grid container spacing={4} style={{ height: '100%' }}>
			<Grid item container xs={12} spacing={4} style={{ height: '35%' }}>
				<Grid item xs={6}>
					<div className={classes.pedSection}>
					<Box className={classes.pedPreview} onClick={() => setOpenPedSelector(true)}>
						<Avatar
						className={classes.currentPedImage}
						src={getPedImageUrl(selectedPed || currentPedModel)}
						variant="square"
						imgProps={{
							onError: (e) => {
							e.target.src = getPedImageUrl(DEFAULT_PED);
							e.target.style.objectFit = "contain";
							}
						}}
						/>
						<Typography>{selectedPed || currentPedModel}</Typography>
					</Box>

					<div className={classes.pedControls}>
						<TextField
						label="Ped Model"
						value={selectedPed}
						onChange={(e) => setSelectedPed(e.target.value)}
						InputProps={{
							endAdornment: selectedPed && (
							<InputAdornment position="end">
								<IconButton onClick={handleResetPed} size="small">
								<Clear />
								</IconButton>
							</InputAdornment>
							)
						}}
						/>

						<TextField
						label="Player ID"
						value={playerSource}
						onChange={(e) => setPlayerSource(e.target.value)}
						type="number"
						/>

						<div className={classes.compactButtonGroup}>
						<Button 
							variant="contained" 
							color="primary" 
							onClick={handleSetCurrentPed}
							disabled={!selectedPed}
						>
							Set My Ped
						</Button>
						<Button
							variant="contained"
							color="secondary"
							onClick={handleSetPlayerPed}
							disabled={!selectedPed || !playerSource}
						>
							Set Player Ped
						</Button>
						</div>
					</div>

					<Dialog open={openPedSelector} onClose={() => setOpenPedSelector(false)} maxWidth="md" fullWidth>
						<DialogTitle>Select Ped</DialogTitle>
						<DialogContent>
						<Paper component="div" style={{ padding: '2px 4px', display: 'flex', alignItems: 'center' }}>
							<InputBase
							placeholder="Search peds..."
							value={searchTerm}
							onChange={(e) => setSearchTerm(e.target.value)}
							style={{ flex: 1 }}
							/>
							<SearchIcon />
						</Paper>
						
						<div className={classes.pedGrid}>
							{filteredPeds.map((ped) => (
							<div key={ped} className={classes.pedItem} onClick={() => {
								setSelectedPed(ped);
								setOpenPedSelector(false);
							}}>
								<Avatar
								className={classes.pedAvatar}
								src={getPedImageUrl(ped)}
								variant="square"
								imgProps={{ onError: (e) => e.target.src = getPedImageUrl(DEFAULT_PED) }}
								/>
								<Typography variant="caption">{ped}</Typography>
							</div>
							))}
						</div>
						</DialogContent>
						<DialogActions>
						<Button onClick={() => setOpenPedSelector(false)}>Close</Button>
						</DialogActions>
					</Dialog>
					</div>
				</Grid>
			</Grid>
		</Grid>
	</div>
  );
}